Paperclip::interpolates :direct_upload_url do |attachment, style|
	attachment.instance.direct_upload_url
end

Paperclip::Attachment.default_options.merge!(
		url: ':s3_path_url',
		path: ':class/:attachment/:id/:filename',
		storage: :s3,
		s3_credentials: Rails.configuration.aws,
		s3_permissions: :private,
		s3_protocol: 'https'
)
