import groovy.json.JsonSlurper
import org.sonatype.nexus.scheduling.TaskInfo

parsed_args = new JsonSlurper().parseText(args)

TaskInfo existingTask = taskScheduler.listsTasks().find { TaskInfo taskInfo ->
  taskInfo.name == parsed_args.name
}

if (existingTask) {
  existingTask.runNow()
}
else
  throw new RuntimeException("Unknown task : " + parsed_args.name)
