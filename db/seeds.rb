# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 3人のUserを作成
User.create(name:"みさ")
User.create(name:"まえこ")

# 家計簿Fileを作成
MoneyFile.create(user_id: 1, title:"個人", description:"個人用の家計簿")
MoneyFile.create(user_id: 1, title:"共有", description:"ふたり用の家計簿")
MoneyFile.create(user_id: 1, title:"勉強", description:"勉強用の家計簿")
MoneyFile.create(user_id: 2, title:"個人", description:"個人用の家計簿")
MoneyFile.create(user_id: 2, title:"共有", description:"ふたり用の家計簿")

# カテゴリーを作成
Category.create(name: '食費', user_id: 1)
Category.create(name: '医療費', user_id: 1)
Category.create(name: '娯楽費', user_id: 1)
Category.create(name: '雑費', user_id: 1)
Category.create(name: 'プレゼント費', user_id: 1)
Category.create(name: '美容費', user_id: 1)
Category.create(name: '交通費', user_id: 1)
Category.create(name: '旅行積立', user_id: 1)
Category.create(name: '臨時費', user_id: 1)

Category.create(name: '娯楽費', user_id: 2)
Category.create(name: '食費', user_id: 2)
Category.create(name: '交通費', user_id: 2)

# 予算を作成
Budget.create(money_file_id: 1,  description: "ひとりの食事", amount: 3000) # 食費
Budget.create(money_file_id: 1,  description: "水とか買うとき", amount: 10000) # 雑費
Budget.create(money_file_id: 1,  description: "なし", amount: 3000) # 交通費
Budget.create(money_file_id: 2,  description: "ふたりの食事", amount: 20000) # 食費
Budget.create(money_file_id: 2,  description: "遊んだ時のお金", amount: 10000) # 娯楽費

Budget.create(money_file_id: 4,  description: "パチンコ", amount: 20000) # 娯楽費
Budget.create(money_file_id: 5, description: "ふたりの食事", amount: 30000) # 食費

# 予算とカテゴリーを紐付ける
BudgetCategory.create(budget_id: 1, category_id: 1)
BudgetCategory.create(budget_id: 2, category_id: 4)
BudgetCategory.create(budget_id: 3, category_id: 7)
BudgetCategory.create(budget_id: 4, category_id: 1)
BudgetCategory.create(budget_id: 5, category_id: 3)
BudgetCategory.create(budget_id: 6, category_id: 10)
BudgetCategory.create(budget_id: 7, category_id: 11)

# Shopを作成
Shop.create(name: "ホリーカフェ", user_id: 1)
Shop.create(name: "スターバックス", user_id: 1)
Shop.create(name: "コープ", user_id: 1)

Shop.create(name: "Super D'station新開地店", user_id: 2)
Shop.create(name: "コープ", user_id: 2)

# PayMethodを作成
PayMethod.create(name: "現金", user_id: 1)
PayMethod.create(name: "三井住友Olive", user_id: 1)
PayMethod.create(name: "dカード", user_id: 1)
PayMethod.create(name: "Paypay", user_id: 1)
PayMethod.create(name: "三井住友銀行", user_id: 1)

PayMethod.create(name: "現金", user_id: 2)

# 支払いデータを作成
Payment.create(budget_id:1, title: "夜ご飯", description: "カレー", amount: 498, date: "2024-01-10") #コープ,dカード
Payment.create(budget_id:2, title: "水", description: "いろはすと白湯", amount: 290, date: "2024-01-09") #現金
Payment.create(budget_id:3, title: "スイカにチャージ", amount: 2000, date: "2024-01-09") #銀行
Payment.create(budget_id:4, title: "西宮神社の屋台", description: "とうもろこし、イカ", amount: 1000, date: "2024-01-09") #現金
Payment.create(budget_id:7, title: "夜ご飯その１", description: "阪神西宮の白鹿", amount: 5000, date: "2024-01-09") #現金
Payment.create(budget_id:7, title: "夜ご飯その２", description: "阪神西宮のエビスバール", amount: 7000, date: "2024-01-09") #現金
Payment.create(budget_id:4, title: "夜ご飯その2", description: "阪神西宮のエビスバール", amount: 5000, date: "2024-01-09") #現金
Payment.create(budget_id:4, title: "夜ご飯その3", description: "今津のうどん一番で親子丼", amount: 500, date: "2024-01-09") #現金
Payment.create(budget_id:7, title: "夜ご飯その3", description: "今津のうどん一番でたこ焼きとうどん", amount: 800, date: "2024-01-09") #現金

# 支払いとMethodを紐づける
PaymentPayMethod.create(payment_id: 1, pay_method_id: 3)
PaymentPayMethod.create(payment_id: 2, pay_method_id: 1)
PaymentPayMethod.create(payment_id: 3, pay_method_id: 5)
PaymentPayMethod.create(payment_id: 4, pay_method_id: 1)
PaymentPayMethod.create(payment_id: 5, pay_method_id: 6)
PaymentPayMethod.create(payment_id: 6, pay_method_id: 6)
PaymentPayMethod.create(payment_id: 7, pay_method_id: 1)
PaymentPayMethod.create(payment_id: 8, pay_method_id: 1)
PaymentPayMethod.create(payment_id: 9, pay_method_id: 6)

# 支払いと店を紐づける
PaymentShop.create(payment_id: 1, shop_id: 3)
