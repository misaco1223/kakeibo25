# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Category.create([{ name: '医療費' }, { name: '食費' }, { name: '娯楽費' }, 
# { name: '交通費' }, { name: 'プレゼント費' }, { name: '臨時費' }, { name: '雑費'}, 
# { name:'水道光熱費'}, { name:'美容費'}])

# 10個のBudgetデータを作成
# 10.times do |i|
# Budget.create(amount: (1000 + i * 100), # 少しずつ増加する金額description: "これはサンプル予算#{i+1}です。",category: Category.all.sample, # ランダムにカテゴリを選択money_file: MoneyFile.find(3))end

10.times do |i|
PaymentDatum.create(
  title: "サンプル支出#{i+1}",
  description: "これはサンプル支出#{i+1}です。",
  amount: (1000 + i * 100), # 少しずつ増加する金額
  budget: Budget.all.sample,
  payment_method: PaymentMethod.all.sample,
  date: Time.zone.now,
)
end
