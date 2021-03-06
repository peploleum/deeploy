import groovy.json.JsonSlurper
import org.sonatype.nexus.repository.config.Configuration

parsed_args = new JsonSlurper().parseText(args)

configuration = new Configuration(
  repositoryName: parsed_args.name,
  recipeName: 'apt-proxy',
  online: true,
  attributes: [
    apt  : [
      distribution: parsed_args.distribution,
      flat: Boolean.valueOf(parsed_args.flat)
    ],
    proxy  : [
      remoteUrl: parsed_args.remote_url,
      contentMaxAge: 1440.0,
      metadataMaxAge: 1440.0
    ],
    httpclient: [
      blocked: false,
      autoBlock: true
    ],
    storage: [
      blobStoreName: parsed_args.blob_store,
      strictContentTypeValidation: Boolean.valueOf(parsed_args.strict_content_validation)
    ],
    negativeCache: [
      enabled: true,
      timeToLive: 1440.0
    ]
  ]
)

def existingRepository = repository.getRepositoryManager().get(parsed_args.name)

if (existingRepository != null) {
  existingRepository.stop()
  configuration.attributes['storage']['blobStoreName'] = existingRepository.configuration.attributes['storage']['blobStoreName']
  existingRepository.update(configuration)
  existingRepository.start()
} else {
  repository.getRepositoryManager().create(configuration)
}
