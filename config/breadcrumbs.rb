crumb :root do
  link "家計簿", root_path
end

crumb :show_money_file do |money_file|
  link money_file.name, money_file_path(money_file)
  parent :money_files
end

crumb :new_money_file do
  link "家計簿新規作成", new_money_file_path
  parent :money_files
end

crumb :edit_money_file do |money_file|
  link "編集", edit_money_file_path(money_file)
  parent :show_money_file, money_file
end

crumb :show_budget do |budget|
  link budget.name, budget_path(budget)
  parent :show_money_file, budget.money_file
end

crumb :new_budget do |budget|
  link "予算新規作成", new_budget_path
  parent :show_money_file, budget.money_file
end

crumb :edit_budget do |budget|
  link "編集", edit_budget_path(budget)
  parent :show_budget, budget
end

crumb :categories do
  link "カテゴリー", categories_path
end

crumb :shops do
  link "店舗", shops_path
end

crumb :pay_methods do
  link "支払い方法", pay_methods_path
end

crumb :new_session do
  link "ログイン", login_path
end

crumb :new_user do
  link "会員登録", new_user_path
  parent :users
end








# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).