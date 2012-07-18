namespace :rbp do
  desc "Create the Rails Best Practices report"
  task :create do
    `rails_best_practices -f html --with-textmate`
  end
  
  desc "Remove old reports"
  task :delete do
    `rm rails_best_practices_output.html`
  end
end
