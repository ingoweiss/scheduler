namespace :scheduler do
  desc "This task just logs to 'scheduler_debug.log' for schedule debugging purposes"
  task :debug do
    logger = Logger.new('scheduler_debug.log')
    logger.info "scheduler ran task"
  end
end
