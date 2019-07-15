namespace :data do

  desc "Importing data"
  task :import => :environment do
    [
        { dev_team_name: 'dt', name: 'ngs_dt_worker_shippingstatus_mercurygate', scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_dt_worker_shippingstatus_mercurygate.git' },
        { dev_team_name: 'dt', name: 'ngs_dt_worker_png_flats',                  scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_dt_worker_png_flats.git' },
        { dev_team_name: 'dt', name: 'ngs_dt_worker_usps_detextro',              scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_dt_worker_usps_detextro.git' },
        { dev_team_name: 'dt', name: 'ngs_dt_worker_shippingstatus_edi',         scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_dt_worker_shippingstatus_edi.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_subscription-service',              scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_subscription-service.git' },
        { dev_team_name: 'ns', name: 'ngs_ns-event-retry-worker',                scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns-event-retry-worker.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_event-worker',                      scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_event-worker.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_sms_service',                       scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_sms_service.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_sms_worker',                        scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_sms_worker.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_sms_worker-resend-otr-data',        scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_sms_worker-resend-otr-data.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_sms_worker-retry',                  scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_sms_worker-retry.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_notification_service',              scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_notification_service.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_notification_worker',               scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_notification_worker.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_notification_worker-retry',         scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_notification_worker-retry.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_email_worker-retry',                scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_email_worker-retry.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_email_worker',                      scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_email_worker.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_facebook_worker-retry',             scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_facebook_worker-retry.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_facebook_worker',                   scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_facebook_worker.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_tracking-poller-scheduler',         scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_tracking-poller-scheduler.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_tracking-poller-worker',            scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_tracking-poller-worker.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_tracking-subscribe-service',        scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_tracking-subscribe-service.git' },
        { dev_team_name: 'ns', name: 'ngs_ns_tracking-subscribe-worker',         scm_repo_url: 'git@bitbucket.org:ngsteam/ngs_ns_tracking-subscribe-worker.git' }
    ].each do |item|
      puts item[:name]
      unless project = Project.find(item[:name])
        project = Project.new(name: item[:name], next_build_id: Jets.config.initial_id)
      end
      project.attrs( { team: item[:dev_team_name], repo_url: item[:scm_repo_url] } )
      project.replace
    end
  end

end