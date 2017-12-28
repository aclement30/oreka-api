require 'csv'
desc 'Import Oreka v1 transactions from CSV'
task :import_oreka => :environment do
  raise Exception.new('This task should not be run more than once!')

  file = ARGV[1]
  puts "Importing #{file}"

  user_alex = User.find(1)
  user_johann = User.find(2)

  # Create initial balance
  initial_balance = Expense.new(
    date: '2014-10-01',
    description: 'Solde initial',
    amount: 404,
    payer_share: 0,
    payer_id: user_johann.id,
    couple_id: user_alex.couple.id,
    category_id: 11,
    created_at: '2014-10-01'
  )
  initial_balance.save!

  CSV.foreach(file, headers: true) do |row|
    if row['type'] == 'expense'
      category = case row['category_id'].to_i
                   when 5 then Category.find_by_name('Épicerie')
                   when 'Other' then Category.find_by_name('Divers')
                   when 9 then Category.find_by_name('Meubles & fournitures')
                   when 8 then Category.find_by_name('Loyer')
                   when 10 then Category.find_by_name('Location de voitures')
                   when 11 then Category.find_by_name('Hôtel / Voyages')
                   when 12 then Category.find_by_name('Restaurant / Take-out')
                   when 13 then Category.find_by_name('Internet')
                   when 15 then Category.find_by_name('Électricité')
                   when 16 then Category.find_by_name('Cellulaire')
                   else Category.find_by_name('Divers')
                 end

      transaction = Expense.new(
          date: row['transaction_date'],
          description: row['merchant'],
          amount: row['amount'].to_f,
          currency: 'CAD',
          payer_share: row['amount'].to_f - row['reimbursement'].to_f,
          payer_id: row['user_id'].to_i == 1 ? user_alex.id : user_johann.id,
          category_id: category.id,
          couple_id: user_alex.couple.id,
          created_at: row['created'],
          notes: row['notes'] != 'NULL' ? row['notes'] : nil,
      )
      transaction.save!
      elsif row['type'] == 'payment'
      transaction = Payment.new(
          date: row['transaction_date'],
          amount: row['amount'].to_f,
          currency: 'CAD',
          payer_id: row['user_id'].to_i == 1 ? user_alex.id : user_johann.id,
          couple_id: user_alex.couple.id,
          created_at: row['created'],
          notes: row['notes'] != 'NULL' ? row['notes'] : nil,
      )
      transaction.save!
    else
      raise Exception.new('Unknown file formatting')
    end
  end
end
