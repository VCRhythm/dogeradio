Paperclip::Attachment.default_options.merge!(
		url: ':s3_path_url',
		path: ':class/:attachment/:id/:filename',
		storage: :s3,
		s3_credentials: Rails.configuration.aws,
		s3_permissions: :private,
		s3_protocol: 'https'
)
