import groovy.json.JsonSlurper
import org.sonatype.nexus.scheduling.TaskInfo
import org.sonatype.nexus.scheduling.TaskScheduler

parsed_args = new JsonSlurper().parseText(args)

TaskScheduler taskScheduler = container.lookup(TaskScheduler.class.getName())

TaskInfo existingTask = taskScheduler.listsTasks().find { TaskInfo taskInfo ->
  taskInfo.name == parsed_args.name
}

if (existingTask) {
  existingTask.runNow()
  existingTask.getCurrentState();
}
else
  throw new RuntimeException("Unknown task : " + parsed_args.name)
