const discord = module.require('discord.js')

module.exports.run = async (bot, message, con, log, role) => {
  if(!role) {
    const Embedasdasd = new discord.MessageEmbed()
    .setColor('#0099ff')
    .setDescription('**Bot Whitelist**')
    .addField('Faid',"```\nI could not find the role Buyer\n```", true)
    .setTimestamp()
    return message.channel.send(Embedasdasd)
  }

  con.query(`Select discord_id FROM whitelistbot Where discord_id = '${message.author.id}'`, function(err, results, fields) {
      if(!results.length) {
          const Embed = new discord.MessageEmbed()
          .setColor('#0099ff')
          .setDescription('**Bot Whitelist**')
          .addField('Error','```\nAre You Not Buyer\n```', true)
          .setTimestamp()
          message.channel.send(Embed)
          log(`[LOG Command] ${message.author.username}, Use Command GetRole`, "red")
      } else {
          if(message.member.roles.cache.some(role => role.name === 'Buyer')){
              const Embed = new discord.MessageEmbed()
              .setColor('#0099ff')
              .setDescription('**Bot Whitelist**')
              .addField('Error','```\nYou Already Have The Role\n```', true)
              .setTimestamp()
              message.channel.send(Embed)
              log(`[LOG Command] ${message.author.username}, Use Command GetRole`, "red")
          } else {
              if(role) message.member.roles.add(role)
              const Embed = new discord.MessageEmbed()
              .setColor('#0099ff')
              .setDescription('**Bot Whitelist**')
              .addField('Success','```\nGave Role Success\n```', true)
              .setTimestamp()
              message.channel.send(Embed)
              log(`[LOG Command] ${message.author.username}, Use Command GetRole`, "green")
          }
      }
  })
}

module.exports.help = {
  name: "getrole"
}