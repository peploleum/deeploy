import groovy.json.JsonSlurper
import org.sonatype.nexus.repository.config.Configuration

parsed_args = new JsonSlurper().parseText(args)

configuration = new Configuration(
  repositoryName: parsed_args.name,
  recipeName: 'apt-hosted',
  online: true,
  attributes: [
    apt  : [
      distribution: parsed_args.distribution
    ],
    aptHosted: [
      assetHistoryLimit: null
    ],
    aptSigning: [
      keypair: parsed_args.keypair,
      passphrase: parsed_args.passphrase
    ],
    storage: [
      blobStoreName: parsed_args.blob_store,
      strictContentTypeValidation: Boolean.valueOf(parsed_args.strict_content_validation),
      writePolicy: "ALLOW_ONCE"
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
