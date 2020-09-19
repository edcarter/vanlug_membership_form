-- A script to create the obt VanLUG main table
-- OBT-Chart-of-Field-Names v5 (September 2019)
-- Acronymns: OBT=one-big-table, PMP=Paid-Memberships-Pro, VFB=Visual-Form-Builder,
-- FSB=???
-- Commented out commands so as not to use them accidentally

DROP DATABASE vanlug_membership;
DROP USER test@localhost;
CREATE DATABASE vanlug_membership;
USE vanlug_membership;

CREATE TABLE membership_obt
(
-- ID Section

id_obt INT(12) UNSIGNED NOT NULL DEFAULT 0 PRIMARY KEY, 
-- This is the obt table id, the primary key, with no other  meaning or value
--  and no PMP/VFB correlate. Since there can be only one auto-incrementing 
--   field per table (next), we use the MAX(id_obt)+1 operation to insert the 
--   next sequential integer into this field as part of the larger INSERT 
--   statement. We use:
--   LOCK TABLES membership_obt;
--   INSERT INTO
--   membership_obt (id_obt) VALUES ((SELECT MAX(id_obt) +1) FROM membership_obt);
--   UNLOCK TABLES membership_obt;
--   Note also that UNSIGNED has to follow the INT(12) declaration, most 
--   probably because it modifies the INT data type. Keyword order matters!

id_vlmbr INT(12) UNSIGNED NOT NULL UNIQUE KEY AUTO_INCREMENT ,
-- This is the new vanlug member id#,  assigned automatically w. New VFB data
-- and New PMP data. New vfb/pmp new member#s begin with 1001. Leave old 
-- numbers as is. Start the auto_increment sequence by assigning 1001 with 
-- "AUTO_INCREMENT = 1001" at the end of the command between the closing 
-- parenthesis ")" and the semi-colon that ends the command as so: ".....
-- .....) AUTO_INCREMENT = 1001 ; ". See below, and note that this is called
-- a 'table option'. Note also that AUTO_INCREMENT sets it's own DEFAULT value
-- so you cannot use DEFAULT with AUTO_INCREMENT.

id_pmp INT(12) UNSIGNED NOT NULL UNIQUE KEY DEFAULT 0 ,
-- This was pmp/mo.id, and is the field for pmp table ids, and is empty for 
-- vfb(fsb?) data. It's needed as connection between obt and pmp tables to 
-- import old data.

id_pmp_usr INT(12) UNSIGNED NOT NULL UNIQUE KEY DEFAULT 0 , 
-- This was pmp/mo.usr_id, and is the field for pmp usr ids ie membership 
-- numbers assigned by pmp earlier. It is empty for vfb data.

id_vfb INT(12) UNSIGNED NOT NULL UNIQUE KEY DEFAUlT 0 ,
-- This is the new table id for vfb, is needed to link vfb table with obt, 
-- empty for pmp, start at 1. Not sure if we can do this as there's only
-- one AUTO_INCREMENT field allowed. Maybe a foreign index?

id_vfb_usr INT(12) UNSIGNED NOT NULL UNIQUE KEY DEFAULT 0 ,
-- This is needed for vfb user id, ie membership numbers assigned by vfb
-- earlier and is empty for  pmp data. Maybe don't need it at all?
-- Personel Section

fname VARCHAR(127) DEFAULT 'xxx' ,
-- This is the first partof pmp/mo.billing_name – a split is required, but
-- perhaps do this manually. This is fsb/mandat/'First Name'*
-- This cannot be NULL but likewise cannot be NOT NULL because there's
-- a default that you want to set ie xxx.  And you cannot use a UNIQUE KEY
-- either as fnames can legitimately be the same. Perhaps an index????

lname VARCHAR(127) DEFAULT 'xxx' ,
-- This is the second part of pmp/mo.billing_name – split required, 
-- but perhaps do this manually. This is fsb/mandat/'Second Name'*

email VARCHAR(127) DEFAULT 'xxx' ,
-- This is not present in pmp/mo, and should be!!! We're getting emails from 
-- somewhere with pmp. Where??? This is fsb/mandat/'Email Address'*

usrname VARCHAR(127) DEFAULT 'xxx' ,
-- This is the login id for use with password, possibly defaulting to email?,
-- How? This is nothing in pmp/mo, and should be!!! we get user names from 
-- somewhere with pmp. Where??? It is fsb/mandat/'User Name / Login ID'*

password  VARCHAR(255) DEFAULT 'empty' ,
-- Should this be in the obt at all? Hex?Text?Encrypted?Hashed?
-- Is this present in pmp/mo in one of the encrypted fields?
-- Is fsb/mandat/'Password'* How to set this up????

phone_num VARCHAR(20) DEFAULT '0' , 
-- This is pmp/mo.billing_phone, and is vfb/mandat/'Phone Number'*

addr1 VARCHAR(127) DEFAULT 'empty' ,
-- This is pmp/mo.billing_street – a split is required ?, do manually?
-- This is vfb/mandat/'Mailing Address 1'*

addr2 VARCHAR(127) DEFAULT 'empty' , 
-- This is pmp/mo.billing_street second part – a split is required?, manual?
-- This is vfb/mandat/'Mailing Address 2'

city VARCHAR(127) DEFAULT 'Vancouver' ,
-- This is pmp/mo.billing_city. This is vfb/mandat/'City'*

prov_state VARCHAR(64) DEFAULT 'B.C.' , 
-- This is pmp/mo.billing_state. This is vfb/mandat/'Province / State'*

postalc_zip VARCHAR(64) DEFAULT 'empty' ,
-- This is pmp/mo.billing_zip. This is vfb/mandat/'Postal Code'*

country VARCHAR(64) DEFAULT 'Canada' , 
-- This is pmp/mo.billing_country and vfb/mandat/'Country'*

comments_expertise VARCHAR(255) DEFAULT 'empty' , 
-- This is pmp/nothingyet comments-expertise-occupation
-- This is vfb/mandat/'Comment' AND 'Expertise Level' – change this!


-- Membership Section

start_date DATE NOT NULL DEFAULT '1970-01-01' ,
-- This is pmp/nothingyet, the first-date-of-membership, and is 
-- vfb/mandat/'Registration date'

expir_date DATE NOT NULL DEFAULT '1970-01-01' ,
-- This is pmp/nothingyet, the last-date-of-membership, and is 
-- vfb/mandat/'Expiry date'.  How to calculate this? Date arithmetic?
-- start_date + 365 ??

mbr_status VARCHAR(64) NOT NULL DEFAULT '???' ,
-- This is pmp/mo.status, ie Active,Inactive,Expired. But how is this 
-- calculated? Based on date? ie if exp_date > today then mbr_status=Active
-- and is nothing yet in vfb/mandat/ 

brd_posit VARCHAR(32) NULL DEFAULT '???' ,
-- This is pmp/nothingyet and is  vfb/mandat/'Holding executive position'
-- In obt should be brd_posit:pres,vp,treas,sect,director, webmaster, 
-- social coord etc

-- ?subscription? Should membership be a subscription? Advantage is 
-- renewals/updates. No. Do renewals another way. Join, Renew, Donate form.
-- Radio buttons, then three seperate processes. Remove this section.
-- Perhaps design an update or proceedure of some sort?

keypunch VARCHAR(32) NULL DEFAULT '???' ,
-- This is pmp/nothing, and is for entering the name of the manual data entry
-- person ie AndrewK, IainK, JohnW, wgm, Billm etc


-- Financial Section

paymt_type VARCHAR(64) NOT NULL DEFAULT '????' ,
-- This is pmp/mo.payment_type and vfb/mandat/'Payment method'
-- PPal or Cash should be the two types of entry 
-- possibly derrived from the form automatically or a radio button

amount VARCHAR(32) NOT NULL DEFAULT '0.00'  ,
-- This is pmp/nothing yet and vfb/???

donation  VARCHAR(32) NULL DEFAULT '0.00'  ,
-- This is pmp/mo.notes and vfb/???

subtotal VARCHAR(32) NOT NULL DEFAULT '0.00'  , 
-- This is pmp/mo.subtotal and vfb/????

total VARCHAR(32) NOT NULL DEFAULT '0.00'  ,
-- This is pmp/mo.total and vfb/????


-- PayPal Section

gateway  VARCHAR(128) NOT NULL DEFAULT '????'  , 
-- This is pmp/mo.gateway and vfb/???

gateway_envr VARCHAR(128) NOT NULL DEFAULT '????'  , 
-- This is pmp/mo.gateway_environment and vfb/???

paymt_trans_id VARCHAR(128) NOT NULL DEFAULT '????'  ,
-- This is pmp/mo.payment_transaction_id and vfb/???

timestamp DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00'
-- This is pmp/mo.timestamp and vfb/????

);
-- end CREATE TABLE parentheses

ALTER TABLE membership_obt AUTO_INCREMENT = 1001;
-- See id_vlmbr in ID section above.


CREATE USER 'test'@'localhost' IDENTIFIED BY 'test';
GRANT INSERT ON vanlug_membership.membership_obt TO 'test'@'localhost';
FLUSH PRIVILEGES;
-- end of command ;


