class FileController < ApplicationController
    before_action :set_s3_direct_post

    def start
        client = Aws::S3::Client.new
        @objects = client.list_objects({bucket: ENV['S3_BUCKET']}).contents
        render :_form
    end

    private
    def set_s3_direct_post
        @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', signature_expiration: (Time.now.utc + 15.minutes))
    end
end
