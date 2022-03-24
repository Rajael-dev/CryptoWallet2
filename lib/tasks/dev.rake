namespace :dev do
  desc 'Configura o ambiente de desenvolvimento'
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando o banco de dados") do
        %x(rails db:drop)
      end
      show_spinner("Criando o banco de dados") { %x(rails db:create) }
      show_spinner("Migrando as tabelas") { %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    else
      puts 'Você não está em ambiente de desenvolvimento'
    end
  end

  desc 'Cadastra as moedas'
  task add_coins: :environment do
    show_spinner('Cadastrando as moedas') do
      coins = [
        {
          description: 'Bitcoin',
          acronym: 'BTC',
          url_image: 'https://imagensemoldes.com.br/wp-content/uploads/2020/09/Imagem-Dinheiro-Bitcoin-PNG.png',
          mining_type: MiningType.find_by(acronym: 'PoW')
        },
        {
          description: 'Ethereum',
          acronym: 'ETH',
          url_image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/ETHEREUM-YOUTUBE-PROFILE-PIC.png/600px-ETHEREUM-YOUTUBE-PROFILE-PIC.png',
          mining_type: MiningType.all.sample
        },
        {
          description: 'Binance Coin',
          acronym: 'BNB',
          url_image: 'https://logospng.org/download/binance-coin/logo-binance-coin-768.png',
          mining_type: MiningType.all.sample
        },
        {
          description: 'Axie Infinity',
          acronym: 'AXS',
          url_image: 'https://s2.coinmarketcap.com/static/img/coins/200x200/6783.png',
          mining_type: MiningType.all.sample
        }
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc 'Cadastra os tipos de mineração'
  task add_mining_types: :environment do
    show_spinner('Cadastrando os tipos de mineração') do
      mining_types = [
        {description: 'Proof of Work', acronym: 'PoW'},
        {description: 'Proof of Stake', acronym: 'PoS'},
        {description: 'Proof of Capacity', acronym: 'PoC'}
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private

  def show_spinner(mensagem)
    spinner = TTY::Spinner.new("[:spinner] #{mensagem}")
    spinner.auto_spin
    yield
    spinner.success("(sucesso!)")
  end
end
