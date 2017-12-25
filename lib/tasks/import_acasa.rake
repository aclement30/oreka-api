require 'csv'
desc 'Import acasa transactions from CSV'
task :import_acasa => :environment do
  file = ARGV[1]
  puts "Importing #{file}"

  user_alex = User.find(1)
  user_johann = User.find(2)

  CSV.foreach(file, headers: true) do |row|
    if row['Cost ID'].present?
      # Skip uncoming transactions
      next if row['Status'] == 'UPCOMING'

      category = case row['Category']
                      when 'Food & Groceries' then Category.find_by_name('Épicerie')
                      when 'Other' then Category.find_by_name('Divers')
                      when 'Home Supplies' then Category.find_by_name('Meubles & fournitures')
                      when 'Home Maintenance' then Category.find_by_name('Meubles & fournitures')
                      when 'Rent / Mortgage' then Category.find_by_name('Loyer')
                      when 'Utilities' then Category.find_by_name('Électricité')
                      when 'Internet / TV / Phone' then Category.find_by_name('Internet')
                      else Category.find_by_name('Divers')
                    end

      transaction = Expense.new(
                        date: row['Due Date'],
                        description: row['Title'],
                        amount: row['Total Amount'].to_f,
                        currency: 'CAD',
                        payer_share: row['Payer'] == 'Alexandre' ? row['Alexandre'].to_f : row['Johann'].to_f,
                        payer_id: row['Payer'] == 'Alexandre' ? user_alex.id : user_johann.id,
                        category_id: category.id,
                        couple_id: user_alex.couple.id,
                        created_at: row['Created At'],
                        deleted_at: row['Status'] == 'DELETED' ? row['Created At'] : nil,
                        notes: row['Notes'],
      )
      transaction.save!
    elsif row['Payment ID'].present?
      transaction = Payment.new(
          date: row['Date'],
          amount: row['Amount'].to_f,
          currency: 'CAD',
          payer_id: row['Payer'] == 'Alexandre' ? user_alex.id : user_johann.id,
          couple_id: user_alex.couple.id,
          created_at: row['Date'],
          deleted_at: row['Status'] == 'DELETED' ? row['Date'] : nil,
      )
      transaction.save!
    else
      raise Exception.new('Unknown file formatting')
    end
  end
end
