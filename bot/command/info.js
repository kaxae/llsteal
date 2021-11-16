const discord = module.require('discord.js')

module.exports.run = async (bot, message, con, log, role, makeid, args) => {
  con.query(`SELECT discord_id,Blacklisted,Reason FROM whitelistbot WHERE discord_id = '${message.author.id}'`, function (err, results, fields) {
      if(results.length) {
        if(results[0].Blacklisted === "True") {
          let blacklisted = results[0].Blacklisted
          let reason = results[0].Reason
          const embedn = new discord.MessageEmbed()
            .setColor('#0099ff')
            .setDescription('**Bot Whitelist**')
            .addField('Info Buyer','```md\n#Blacklist = '+blacklisted+'\n#Reason = '+reason+'\n```', true)
            .setTimestamp()
            message.author.send(embedn).catch(error => {
                const embed2 = new discord.MessageEmbed()
                .setColor('#0099ff')
                .setDescription('**Bot Whitelist**')
                .addField('Send Message Fail','```\nI cannot message you, open your messages!\n```', true)
                .setTimestamp()
                message.channel.send(embed2)
            })
        } else {
            con.query(`SELECT userkey,hwid,ip,Blacklisted,created_at FROM whitelistbot WHERE discord_id = '${message.author.id}'`, function(err, results, fields) {
              let userkey = results[0].userkey
              let hwids = results[0].hwid
              let ips = results[0].ip
              let created_at = results[0].created_at
              const Embed = new discord.MessageEmbed()
              .setColor('#0099ff')
              .setDescription('**Bot Whitelist**')
              .addField('Info Buyer','```md\n#ID = '+ message.author.id +'\n#Key = '+ userkey +'\n#Hwid = '+ hwids +'\n#IP = '+ ips +'```', true)
              .setTimestamp()
              message.author.send(Embed).catch(error => {
                  const embed = new discord.MessageEmbed()
                  .setColor('#0099ff')
                  .setDescription('**Bot Whitelist**')
                  .addField('Send Message Fail','```\nI cannot message you, open your messages!\n```', true)
                  .setTimestamp()
                  message.channel.send(embed)
              })
            })
        }
      } else {
          const Embed = new discord.MessageEmbed()
          .setColor('#0099ff')
          .setDescription('**Bot Whitelist**')
          .addField('Error','```\nAre You Not Buyer\n```', true)
          .setTimestamp()
          message.channel.send(Embed)
      }
  })
}

module.exports.help = {
  name: "info"
}
