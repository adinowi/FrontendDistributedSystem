class FileController < ApplicationController
    before_action :set_s3_direct_post
    skip_before_action :verify_authenticity_token  

    def start
        client = Aws::S3::Client.new
        @objects = client.list_objects({bucket: ENV['S3_BUCKET']}).contents
        render :_form
    end

    def send_to_worker
        sqs = Aws::SQS::Client.new
        entries = Array.new(params[:keys].size)
        i=0
        message_group_id = SecureRandom.uuid
        params[:keys].each do |key|
            body = {
                key: key,
                operation: params[:operation],
                value: params[:value]
            }
            obj = {
                id: 'msg' + i.to_s,
                message_body: JSON[body].to_s,
                message_group_id: message_group_id,
                message_deduplication_id: SecureRandom.uuid
            }
            entries[i] = obj
            i += 1
        end
        sqs.send_message_batch({
            queue_url: ENV['SQS_URL'],
            entries: entries
            })
        redirect_to action: "start"
    end

    private
    def set_s3_direct_post
        @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', signature_expiration: (Time.now.utc + 15.minutes), success_action_redirect: request.base_url + "/start")
    end
end
