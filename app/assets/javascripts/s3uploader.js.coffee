jQuery ->
	$("#s3_uploader").S3Uploader
		before_add: (file) ->
			if /(\.|\/)(mp3)$/i.test(file.type)
				true
			else
				false
