desc 'Envia emails para os usuários com resumo dos contratos'


task send_warning_email: :environment do

  fiscais = User.where(role: 'Fiscal')

  puts "Foram encontrados #{fiscais.count}" 

  fiscais.each do | fiscal |
    Deadline.week_deadline_email(fiscal).deliver!
    puts "Email enviado para #{fiscal.name} - no Email: #{fiscal.email}"
  end

end
