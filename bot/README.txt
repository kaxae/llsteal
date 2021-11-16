* Create Table

CREATE TABLE whitelistbot ( 
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
userkey VARCHAR(255) NOT NULL UNIQUE, 
discord_id VARCHAR(255) NOT NULL,
hwid VARCHAR(255) NOT NULL,
ip VARCHAR(255) NOT NULL,
Blacklisted VARCHAR(255) NOT NULL,
Reason VARCHAR(255) NOT NULL, created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
)

* Create Role

- Buyer
- Whitelister