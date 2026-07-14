# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

data = [
  {
    question: "Owning 55,000 of them, Ted Turner has the world's largest private collection of _____.",
    lies: [
      "cowboy boots",
      "vintage radios",
      "Ostriches",
      "pocket watches",
      "Coca-Cola bottles",
      "sailboats",
      "deer antlers",
      "old maps",
      "telephones",
      "horseshoes",
      "autographs",
      "Native American artifacts"
    ],
    truth: "Bison",
    order: 1,
    points: 1000
  },
  {
    question: "A study published in the journal Anthrozoo reported that cows produce 5% more milk when they are given _____.",
    lies: [
      "classical music",
      "warm water",
      "extra sunlight",
      "salt licks",
      "fresh hay",
      "calming scents",
      "red blankets",
      "mirrors",
      "peppermints",
      "more shade",
      "blue buckets",
      "massage sessions"
    ],
    truth: "Names",
    order: 2,
    points: 1000
  },
  {
    question: "In 2002, Bruce Willis sent 12,000 boxes of _____ to U.S. soldiers in Afghanistan.",
    lies: [
      "baseball cards",
      "canned beans",
      "protein bars",
      "comic books",
      "DVD box sets",
      "batteries",
      "coffee tins",
      "socks",
      "peanut butter",
      "magazines",
      "puzzle boxes",
      "chewing gum"
    ],
    truth: "Girl Scout Cookies",
    order: 3,
    points: 1000
  },
  {
    question: "Strangely, a 2015 study conducted by professors in Finland and California came to the conclusion that there are too many ____.",
    lies: [
      "Smartphones",
      "Passwords",
      "Netflix Accounts",
      "Social Media Platforms",
      "Email Addresses",
      "Delivery Services",
      "Streaming Subscriptions",
      "Furniture Brands",
      "Coffee Shops",
      "Pharmaceutical Drugs",
      "News Outlets",
      "Vacation Destinations"
    ],
    truth: "Studies",
    order: 4,
    points: 2000
  },
  {
    question: "In 2017, police in Lakewood, FL were called about a man who was _____ in a busy street.",
    lies: [
      "Tap Dancing",
      "Doing Pushups",
      "Reciting Poetry",
      "Doing Backflips",
      "juggling",
      "meditating",
      "Breakdancing",
      "singing",
      "fishing",
      "painting",
      "sunbathing",
      "playing violin"
    ],
    truth: "Eating Pancakes",
    order: 5,
    points: 2000
  },
  {
    question: "As France has begun growing more corn, they've noticed a shocking side effect: Their cornfields are full of _____.",
    lies: [
      "Rust Disease",
      "Parasitic Wasps",
      "Mold Spores",
      "Invasive Beetles",
      "Fungal Infections",
      "Aggressive Weeds",
      "Soil Erosion",
      "Destructive Locusts",
      "Poisonous Snakes",
      "Stray Cats",
      "Plastic Debris",
      "Invasive Ivy"
    ],
    truth: "Cannibal Hamsters",
    order: 6,
    points: 2000
  },
  {
    question: "A-1 Pictures produced a 2013 movie based on a popular Japanese manga that features _____ and _____ living together as roommates in Tokyo.",
    lies: [
      "Batman and Robin",
      "Dracula and Frankenstein",
      "Sherlock and Watson",
      "Zeus and Thor",
      "Mario and Luigi",
      "Santa and the Tooth Fairy",
      "Cain and Abel",
      "Elvis and Marilyn",
      "Hamlet and Ophelia",
      "Pope and Obama",
      "Buddha and Gandhi",
      "Sherlock and Moriarty"
    ],
    truth: "Jesus and Buddha",
    order: 7,
    points: 3000
  },
  {
    question: "Oddly enough, the #1 single on the UK's top 100 list in January of 2001 was _____.",
    lies: [
      "Mambo No. 5",
      "Can We Fix It?",
      "It's Raining Men",
      "Barbie Girl",
      "Crazy In Love",
      "Who Let the Dogs Out?",
      "Oops!... I Did It Again",
      "Toxic",
      "Wannabe",
      "Smooth",
      "Blue (Da Ba Dee)",
      "Teenage Dirtbag"
    ],
    truth: "Bob The Builder",
    order: 8,
    points: 3000
  }
]

AudienceVote.delete_all
AudienceChoice.delete_all
Vote.delete_all
Answer.delete_all
Question.delete_all
Player.delete_all
AudiencePlayer.delete_all
Game.delete_all

game = Game.create(code: 'asdf')

data.each do |entry|
  question = Question.create!(
    question: entry[:question],
    game: game,
    order: entry[:order],
    points: entry[:points]
  )
  Answer.create!(question: question, text: entry[:truth], truth: true)

  entry[:lies].first(8).each do |our_lie|
    Lie.create!(text: our_lie, audience: false, question: question)
  end

  entry[:lies].last(4).each do |audience_lie|
    Lie.create!(text: audience_lie, audience: true, question: question)
  end
end
