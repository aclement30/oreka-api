require 'csv'
desc 'Import bulk transactions from CSV'
task :import_bulk => :environment do
  file = ARGV[1]
  puts "Importing #{file}"

  user_alex = User.find(1)

  CSV.foreach(file, headers: true, col_sep: ';') do |row|
    category = Category.find_by_name(row['category'])

    amount = row['amount'].to_s.gsub(',', '.').to_f
    payer_share = row['payer_share'].to_s.gsub(',', '.').to_f

    if category.nil?
      raise "Unknown category '#{row['category']}' for [#{row['description']}, #{amount} $, #{row['date']}]"
    end

    if row['payer_share'].to_f > row['amount'].to_f
      raise "Payer share cannot be higher than transaction amount for [#{row['description']}, #{amount} $, #{row['date']}]"
    end

    transaction = Expense.new(
        date: row['date'],
        description: row['description'],
        amount: amount,
        currency: 'CAD',
        payer_share: payer_share,
        payer_id: row['payer_id'].to_i,
        category_id: category.id,
        couple_id: user_alex.couple.id,
        created_at: row['created'],
        notes: row['notes'] != '' ? row['notes'] : nil,
        )
    transaction.save!
  end
end
