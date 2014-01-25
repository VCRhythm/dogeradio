Paperclip::Attachment.default_options.merge!(
		url: ':s3_path_url',
		path: ':class/:attachment/:id/:style/:escaped_filename',
		storage: :s3,
		s3_credentials: Rails.configuration.aws,
		s3_permissions: :private,
		s3_protocol: 'https'
)
Paperclip.interpolates('escaped_filename') do |attachment, style|
	s = basename(attachment, style)
	s.gsub!(/'/,'')
	return s+ "." + extension(attachment, style)
end
