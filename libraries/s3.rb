#
# Copyright 2012-2016, Brandon Adams and other contributors.
# Copyright 2013-2016, Balanced, Inc.
# Copyright 2016, Noah Kantrowitz
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'time'
require 'openssl'
require 'base64'


class Citadel
  # Simple read-only S3 client.
  #
  # @since 1.0.0
  # @api private
  module S3
    extend self

    # Get an object from S3.
    #
    # @param bucket [String] Name of the bucket to use.
    # @param path [String] Path to the object.
    # @param access_key_id [String] AWS access key ID.
    # @param secret_access_key [String] AWS secret access key.
    # @param token [String, nil] AWS IAM token.
    # @param region [String] S3 bucket region.
    # @return [String] The S3 object contents.
    def get(bucket:, path:, access_key_id:, secret_access_key:, token: nil, region: nil)
      begin
        require 'aws-sdk'
      rescue LoadError
        raise 'Citadel requires `aws-sdk` ~> 3.0.0'
      end

      region ||= 'us-east-1' # Most buckets.
      path = path[1..-1] if path[0] == '/'

      begin
        client = Aws::S3::Client.new(
          region: region,
          access_key_id: access_key_id,
          secret_access_key: secret_access_key,
          session_token: token
        )
        s3 = Aws::S3::Resource.new(client: client)
        bucket = s3.bucket(bucket)
        object = bucket.object(path).get
        return object.body.read
      rescue Aws::Errors::ServiceError => e
        raise CitadelError.new("Unable to download #{path}: #{e}")
      end
    end
  end
end
