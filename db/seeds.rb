# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# All 32 teams
alg = Team.create!(acronym: 'ALG', group: 'H', name_en: 'Algeria',                name_pt: 'Algéria')
arg = Team.create!(acronym: 'ARG', group: 'F', name_en: 'Argentina',              name_pt: 'Argentina')
aus = Team.create!(acronym: 'AUS', group: 'B', name_en: 'Australia',              name_pt: 'Austrália')
bel = Team.create!(acronym: 'BEL', group: 'H', name_en: 'Belgium',                name_pt: 'Bélgica')
bih = Team.create!(acronym: 'BIH', group: 'F', name_en: 'Bosnia and Herzegovina', name_pt: 'Bósnia e Herzegovina')
bra = Team.create!(acronym: 'BRA', group: 'A', name_en: 'Brazil',                 name_pt: 'Brasil')
chi = Team.create!(acronym: 'CHI', group: 'B', name_en: 'Chile',                  name_pt: 'Chile')
civ = Team.create!(acronym: 'CIV', group: 'C', name_en: "Côte d'Ivoire",          name_pt: 'Costa do Marfim')
cmr = Team.create!(acronym: 'CMR', group: 'A', name_en: 'Cameroon',               name_pt: 'Camarões')
col = Team.create!(acronym: 'COL', group: 'C', name_en: 'Colombia',               name_pt: 'Colômbia')
crc = Team.create!(acronym: 'CRC', group: 'D', name_en: 'Costa Rica',             name_pt: 'Costa Rica')
cro = Team.create!(acronym: 'CRO', group: 'A', name_en: 'Croatia',                name_pt: 'Croácia')
ecu = Team.create!(acronym: 'ECU', group: 'E', name_en: 'Ecuador',                name_pt: 'Equador')
eng = Team.create!(acronym: 'ENG', group: 'D', name_en: 'England',                name_pt: 'Inglaterra')
esp = Team.create!(acronym: 'ESP', group: 'B', name_en: 'Spain',                  name_pt: 'Espanha')
fra = Team.create!(acronym: 'FRA', group: 'E', name_en: 'France',                 name_pt: 'França')
ger = Team.create!(acronym: 'GER', group: 'G', name_en: 'Germany',                name_pt: 'Alemanha')
gha = Team.create!(acronym: 'GHA', group: 'G', name_en: 'Ghana',                  name_pt: 'Gana')
gre = Team.create!(acronym: 'GRE', group: 'C', name_en: 'Greece',                 name_pt: 'Grécia')
hon = Team.create!(acronym: 'HON', group: 'E', name_en: 'Honduras',               name_pt: 'Honduras')
irn = Team.create!(acronym: 'IRN', group: 'F', name_en: 'Iran',                   name_pt: 'Irã')
ita = Team.create!(acronym: 'ITA', group: 'D', name_en: 'Italy',                  name_pt: 'Itália')
jpn = Team.create!(acronym: 'JPN', group: 'C', name_en: 'Japan',                  name_pt: 'Japão')
kor = Team.create!(acronym: 'KOR', group: 'H', name_en: 'Korea Republic',         name_pt: 'Coreia do Sul')
mex = Team.create!(acronym: 'MEX', group: 'A', name_en: 'Mexico',                 name_pt: 'México')
ned = Team.create!(acronym: 'NED', group: 'B', name_en: 'Netherlands',            name_pt: 'Holanda')
nga = Team.create!(acronym: 'NGA', group: 'F', name_en: 'Nigeria',                name_pt: 'Nigéria')
por = Team.create!(acronym: 'POR', group: 'G', name_en: 'Portugal',               name_pt: 'Portugal')
rus = Team.create!(acronym: 'RUS', group: 'H', name_en: 'Russia',                 name_pt: 'Rússia')
sui = Team.create!(acronym: 'SUI', group: 'E', name_en: 'Switzerland',            name_pt: 'Suíça')
uru = Team.create!(acronym: 'URU', group: 'D', name_en: 'Uruguay',                name_pt: 'Uruguai')
usa = Team.create!(acronym: 'USA', group: 'G', name_en: 'USA',                    name_pt: 'EUA')

# All 64 matches
# group phase
m01 = Match.create!(number:  1, round: 'group', group: 'A', played_on: 'sp', played_at: '2014-06-12 17:00:00 -0300'.to_time, team_a: bra, team_b: cro)
m02 = Match.create!(number:  2, round: 'group', group: 'A', played_on: 'rn', played_at: '2014-06-13 13:00:00 -0300'.to_time, team_a: mex, team_b: cmr)
m03 = Match.create!(number:  3, round: 'group', group: 'B', played_on: 'ba', played_at: '2014-06-13 16:00:00 -0300'.to_time, team_a: esp, team_b: ned)
m04 = Match.create!(number:  4, round: 'group', group: 'B', played_on: 'mt', played_at: '2014-06-13 18:00:00 -0400'.to_time, team_a: chi, team_b: aus)
m05 = Match.create!(number:  5, round: 'group', group: 'C', played_on: 'mg', played_at: '2014-06-14 13:00:00 -0300'.to_time, team_a: col, team_b: gre)
m06 = Match.create!(number:  6, round: 'group', group: 'C', played_on: 'pe', played_at: '2014-06-14 22:00:00 -0300'.to_time, team_a: civ, team_b: jpn)
m07 = Match.create!(number:  7, round: 'group', group: 'D', played_on: 'ce', played_at: '2014-06-14 16:00:00 -0300'.to_time, team_a: uru, team_b: crc)
m08 = Match.create!(number:  8, round: 'group', group: 'D', played_on: 'am', played_at: '2014-06-14 18:00:00 -0400'.to_time, team_a: eng, team_b: ita)
m09 = Match.create!(number:  9, round: 'group', group: 'E', played_on: 'df', played_at: '2014-06-15 13:00:00 -0300'.to_time, team_a: sui, team_b: ecu)
m10 = Match.create!(number: 10, round: 'group', group: 'E', played_on: 'rs', played_at: '2014-06-15 16:00:00 -0300'.to_time, team_a: fra, team_b: hon)
m11 = Match.create!(number: 11, round: 'group', group: 'F', played_on: 'rj', played_at: '2014-06-15 19:00:00 -0300'.to_time, team_a: arg, team_b: bih)
m12 = Match.create!(number: 12, round: 'group', group: 'F', played_on: 'pr', played_at: '2014-06-16 16:00:00 -0300'.to_time, team_a: irn, team_b: nga)
m13 = Match.create!(number: 13, round: 'group', group: 'G', played_on: 'ba', played_at: '2014-06-16 13:00:00 -0300'.to_time, team_a: ger, team_b: por)
m14 = Match.create!(number: 14, round: 'group', group: 'G', played_on: 'rn', played_at: '2014-06-16 19:00:00 -0300'.to_time, team_a: gha, team_b: usa)
m15 = Match.create!(number: 15, round: 'group', group: 'H', played_on: 'mg', played_at: '2014-06-17 13:00:00 -0300'.to_time, team_a: bel, team_b: alg)
m16 = Match.create!(number: 16, round: 'group', group: 'H', played_on: 'mt', played_at: '2014-06-17 18:00:00 -0400'.to_time, team_a: rus, team_b: kor)
m17 = Match.create!(number: 17, round: 'group', group: 'A', played_on: 'ce', played_at: '2014-06-17 16:00:00 -0300'.to_time, team_a: bra, team_b: mex)
m18 = Match.create!(number: 18, round: 'group', group: 'A', played_on: 'am', played_at: '2014-06-18 18:00:00 -0400'.to_time, team_a: cmr, team_b: cro)
m19 = Match.create!(number: 19, round: 'group', group: 'B', played_on: 'rj', played_at: '2014-06-18 16:00:00 -0300'.to_time, team_a: esp, team_b: chi)
m20 = Match.create!(number: 20, round: 'group', group: 'B', played_on: 'rs', played_at: '2014-06-18 13:00:00 -0300'.to_time, team_a: aus, team_b: ned)
m21 = Match.create!(number: 21, round: 'group', group: 'C', played_on: 'df', played_at: '2014-06-19 13:00:00 -0300'.to_time, team_a: col, team_b: civ)
m22 = Match.create!(number: 22, round: 'group', group: 'C', played_on: 'rn', played_at: '2014-06-19 19:00:00 -0300'.to_time, team_a: jpn, team_b: gre)
m23 = Match.create!(number: 23, round: 'group', group: 'D', played_on: 'sp', played_at: '2014-06-19 16:00:00 -0300'.to_time, team_a: uru, team_b: eng)
m24 = Match.create!(number: 24, round: 'group', group: 'D', played_on: 'pe', played_at: '2014-06-20 13:00:00 -0300'.to_time, team_a: ita, team_b: crc)
m25 = Match.create!(number: 25, round: 'group', group: 'E', played_on: 'ba', played_at: '2014-06-20 16:00:00 -0300'.to_time, team_a: sui, team_b: fra)
m26 = Match.create!(number: 26, round: 'group', group: 'E', played_on: 'pr', played_at: '2014-06-20 19:00:00 -0300'.to_time, team_a: hon, team_b: ecu)
m27 = Match.create!(number: 27, round: 'group', group: 'F', played_on: 'mg', played_at: '2014-06-21 13:00:00 -0300'.to_time, team_a: arg, team_b: irn)
m28 = Match.create!(number: 28, round: 'group', group: 'F', played_on: 'mt', played_at: '2014-06-21 18:00:00 -0400'.to_time, team_a: nga, team_b: bih)
m29 = Match.create!(number: 29, round: 'group', group: 'G', played_on: 'ce', played_at: '2014-06-21 16:00:00 -0300'.to_time, team_a: ger, team_b: gha)
m30 = Match.create!(number: 30, round: 'group', group: 'G', played_on: 'am', played_at: '2014-06-22 18:00:00 -0400'.to_time, team_a: usa, team_b: por)
m31 = Match.create!(number: 31, round: 'group', group: 'H', played_on: 'rj', played_at: '2014-06-22 13:00:00 -0300'.to_time, team_a: bel, team_b: rus)
m32 = Match.create!(number: 32, round: 'group', group: 'H', played_on: 'rs', played_at: '2014-06-22 16:00:00 -0300'.to_time, team_a: kor, team_b: alg)
m33 = Match.create!(number: 33, round: 'group', group: 'A', played_on: 'df', played_at: '2014-06-23 17:00:00 -0300'.to_time, team_a: cmr, team_b: bra)
m34 = Match.create!(number: 34, round: 'group', group: 'A', played_on: 'pe', played_at: '2014-06-23 17:00:00 -0300'.to_time, team_a: cro, team_b: mex)
m35 = Match.create!(number: 35, round: 'group', group: 'B', played_on: 'pr', played_at: '2014-06-23 13:00:00 -0300'.to_time, team_a: aus, team_b: esp)
m36 = Match.create!(number: 36, round: 'group', group: 'B', played_on: 'sp', played_at: '2014-06-23 13:00:00 -0300'.to_time, team_a: ned, team_b: chi)
m37 = Match.create!(number: 37, round: 'group', group: 'C', played_on: 'mt', played_at: '2014-06-24 16:00:00 -0400'.to_time, team_a: jpn, team_b: col)
m38 = Match.create!(number: 38, round: 'group', group: 'C', played_on: 'ce', played_at: '2014-06-24 17:00:00 -0300'.to_time, team_a: gre, team_b: civ)
m39 = Match.create!(number: 39, round: 'group', group: 'D', played_on: 'rn', played_at: '2014-06-24 13:00:00 -0300'.to_time, team_a: ita, team_b: uru)
m40 = Match.create!(number: 40, round: 'group', group: 'D', played_on: 'mg', played_at: '2014-06-24 13:00:00 -0300'.to_time, team_a: crc, team_b: eng)
m41 = Match.create!(number: 41, round: 'group', group: 'E', played_on: 'am', played_at: '2014-06-25 16:00:00 -0400'.to_time, team_a: hon, team_b: sui)
m42 = Match.create!(number: 42, round: 'group', group: 'E', played_on: 'rj', played_at: '2014-06-25 17:00:00 -0300'.to_time, team_a: ecu, team_b: fra)
m43 = Match.create!(number: 43, round: 'group', group: 'F', played_on: 'rs', played_at: '2014-06-25 13:00:00 -0300'.to_time, team_a: nga, team_b: arg)
m44 = Match.create!(number: 44, round: 'group', group: 'F', played_on: 'ba', played_at: '2014-06-25 13:00:00 -0300'.to_time, team_a: bih, team_b: irn)
m45 = Match.create!(number: 45, round: 'group', group: 'G', played_on: 'pe', played_at: '2014-06-26 13:00:00 -0300'.to_time, team_a: usa, team_b: ger)
m46 = Match.create!(number: 46, round: 'group', group: 'G', played_on: 'df', played_at: '2014-06-26 13:00:00 -0300'.to_time, team_a: por, team_b: gha)
m47 = Match.create!(number: 47, round: 'group', group: 'H', played_on: 'sp', played_at: '2014-06-26 17:00:00 -0300'.to_time, team_a: kor, team_b: bel)
m48 = Match.create!(number: 48, round: 'group', group: 'H', played_on: 'pr', played_at: '2014-06-26 17:00:00 -0300'.to_time, team_a: alg, team_b: rus)
# round of sixteen
m49 = Match.create!(number: 49, round: 'round_16', played_on: 'mg', played_at: '2014-06-28 13:00:00 -0300'.to_time) # team_a: 1A, team_b: 2B
m50 = Match.create!(number: 50, round: 'round_16', played_on: 'rj', played_at: '2014-06-28 17:00:00 -0300'.to_time) # team_a: 1C, team_b: 2D
m51 = Match.create!(number: 51, round: 'round_16', played_on: 'ce', played_at: '2014-06-29 13:00:00 -0300'.to_time) # team_a: 1b, team_b: 2a
m52 = Match.create!(number: 52, round: 'round_16', played_on: 'pe', played_at: '2014-06-29 17:00:00 -0300'.to_time) # team_a: 1d, team_b: 2c
m53 = Match.create!(number: 53, round: 'round_16', played_on: 'df', played_at: '2014-06-30 13:00:00 -0300'.to_time) # team_a: 1e, team_b: 2f
m54 = Match.create!(number: 54, round: 'round_16', played_on: 'rs', played_at: '2014-06-30 17:00:00 -0300'.to_time) # team_a: 1g, team_b: 2h
m55 = Match.create!(number: 55, round: 'round_16', played_on: 'sp', played_at: '2014-07-01 13:00:00 -0300'.to_time) # team_a: 1f, team_b: 2e
m56 = Match.create!(number: 56, round: 'round_16', played_on: 'ba', played_at: '2014-07-01 17:00:00 -0300'.to_time) # team_a: 1h, team_b: 2g
# quarter finals
m57 = Match.create!(number: 57, round: 'quarter', played_on: 'ce', played_at: '2014-07-04 17:00:00 -0300'.to_time) # team_a: w49, team_b: w50
m58 = Match.create!(number: 58, round: 'quarter', played_on: 'rj', played_at: '2014-07-04 13:00:00 -0300'.to_time) # team_a: w53, team_b: w54
m59 = Match.create!(number: 59, round: 'quarter', played_on: 'ba', played_at: '2014-07-05 17:00:00 -0300'.to_time) # team_a: w51, team_b: w52
m60 = Match.create!(number: 60, round: 'quarter', played_on: 'df', played_at: '2014-07-05 13:00:00 -0300'.to_time) # team_a: w55, team_b: w56
# semi finals
m61 = Match.create!(number: 61, round: 'semi', played_on: 'mg', played_at: '2014-07-08 17:00:00 -0300'.to_time) # team_a: w57, team_b: w58
m62 = Match.create!(number: 62, round: 'semi', played_on: 'sp', played_at: '2014-07-09 17:00:00 -0300'.to_time) # team_a: w59, team_b: w60
# finals
m63 = Match.create!(number: 63, round: 'final', played_on: 'df', played_at: '2014-07-12 17:00:00 -0300'.to_time) # team_a: l61, team_b: l62
m64 = Match.create!(number: 64, round: 'final', played_on: 'rj', played_at: '2014-07-13 16:00:00 -0300'.to_time) # team_a: w61, team_b: w62

# All +- 736 players
# alg, http://en.wikipedia.org/wiki/Algeria_national_football_team#Current_squad
Player.create!(team: alg, position: 'goalkeeper', name: 'Mohamed Zemmamouche')
Player.create!(team: alg, position: 'goalkeeper', name: 'Azzedine Doukha')
Player.create!(team: alg, position: 'field', name: 'Madjid Bougherra')
Player.create!(team: alg, position: 'field', name: 'Rafik Halliche')
Player.create!(team: alg, position: 'field', name: 'Djamel Mesbah')
Player.create!(team: alg, position: 'field', name: 'Essaïd Belkalem')
Player.create!(team: alg, position: 'field', name: 'Liassine Cadamuro-Bentaïba')
Player.create!(team: alg, position: 'field', name: 'Faouzi Ghoulam')
Player.create!(team: alg, position: 'field', name: 'Aïssa Mandi')
Player.create!(team: alg, position: 'field', name: 'Ali Rial')
Player.create!(team: alg, position: 'field', name: 'Medhi Lacen')
Player.create!(team: alg, position: 'field', name: 'Adlène Guedioura')
Player.create!(team: alg, position: 'field', name: 'Hassan Yebda')
Player.create!(team: alg, position: 'field', name: 'Foued Kadir')
Player.create!(team: alg, position: 'field', name: 'Mehdi Mostefa')
Player.create!(team: alg, position: 'field', name: 'Saphir Taïder')
Player.create!(team: alg, position: 'field', name: 'Abdelmoumene Djabou')
Player.create!(team: alg, position: 'field', name: 'Yacine Brahimi')
Player.create!(team: alg, position: 'field', name: 'Nabil Bentaleb')
Player.create!(team: alg, position: 'field', name: 'Zinedine Ferhat')
Player.create!(team: alg, position: 'field', name: 'Rafik Djebbour')
Player.create!(team: alg, position: 'field', name: 'El Arbi Hillel Soudani')
Player.create!(team: alg, position: 'field', name: 'Islam Slimani')

# arg, http://en.wikipedia.org/wiki/Argentina_national_football_team#Current_squad
Player.create!(team: arg, position: 'goalkeeper', name: 'Sergio Romero')
Player.create!(team: arg, position: 'goalkeeper', name: 'Mariano Andújar')
Player.create!(team: arg, position: 'goalkeeper', name: 'Agustín Orión')
Player.create!(team: arg, position: 'field', name: 'Pablo Zabaleta')
Player.create!(team: arg, position: 'field', name: 'Federico Fernández')
Player.create!(team: arg, position: 'field', name: 'Marcos Rojo')
Player.create!(team: arg, position: 'field', name: 'Ezequiel Garay')
Player.create!(team: arg, position: 'field', name: 'Nicolás Otamendi')
Player.create!(team: arg, position: 'field', name: 'Hugo Campagnaro')
Player.create!(team: arg, position: 'field', name: 'José María Basanta')
Player.create!(team: arg, position: 'field', name: 'Lisandro Ezequiel López')
Player.create!(team: arg, position: 'field', name: 'Gino Peruzzi')
Player.create!(team: arg, position: 'field', name: 'Javier Mascherano')
Player.create!(team: arg, position: 'field', name: 'Maxi Rodríguez')
Player.create!(team: arg, position: 'field', name: 'Fernando Gago')
Player.create!(team: arg, position: 'field', name: 'Ángel di María')
Player.create!(team: arg, position: 'field', name: 'Éver Banega')
Player.create!(team: arg, position: 'field', name: 'José Ernesto Sosa')
Player.create!(team: arg, position: 'field', name: 'Lucas Biglia')
Player.create!(team: arg, position: 'field', name: 'Augusto Fernández')
Player.create!(team: arg, position: 'field', name: 'Ricardo Álvarez')
Player.create!(team: arg, position: 'field', name: 'Lionel Messi')
Player.create!(team: arg, position: 'field', name: 'Sergio Agüero')
Player.create!(team: arg, position: 'field', name: 'Gonzalo Higuaín')
Player.create!(team: arg, position: 'field', name: 'Ezequiel Lavezzi')
Player.create!(team: arg, position: 'field', name: 'Rodrigo Palacio')

# aus, http://en.wikipedia.org/wiki/Australia_national_football_team#Current_squad
Player.create!(team: aus, position: 'goalkeeper', name: 'Mathew Ryan')
Player.create!(team: aus, position: 'goalkeeper', name: 'Brad Jones')
Player.create!(team: aus, position: 'goalkeeper', name: 'Mitchell Langerak')
Player.create!(team: aus, position: 'field', name: 'Luke Wilkshire')
Player.create!(team: aus, position: 'field', name: 'Matthew Špiranović')
Player.create!(team: aus, position: 'field', name: 'Ryan McGowan')
Player.create!(team: aus, position: 'field', name: 'Ivan Franjić')
Player.create!(team: aus, position: 'field', name: 'Jason Davidson')
Player.create!(team: aus, position: 'field', name: 'Curtis Good')
Player.create!(team: aus, position: 'field', name: 'Alex Wilkinson')
Player.create!(team: aus, position: 'field', name: 'Brett Holman')
Player.create!(team: aus, position: 'field', name: 'Matt McKay')
Player.create!(team: aus, position: 'field', name: 'Mile Jedinak')
Player.create!(team: aus, position: 'field', name: 'Mark Milligan')
Player.create!(team: aus, position: 'field', name: 'Dario Vidošić')
Player.create!(team: aus, position: 'field', name: 'Tommy Oar')
Player.create!(team: aus, position: 'field', name: 'James Holland')
Player.create!(team: aus, position: 'field', name: 'Tom Rogić')
Player.create!(team: aus, position: 'field', name: 'Adam Sarota')
Player.create!(team: aus, position: 'field', name: 'Oliver Bozanić')
Player.create!(team: aus, position: 'field', name: 'Massimo Luongo')
Player.create!(team: aus, position: 'field', name: 'Tim Cahill')
Player.create!(team: aus, position: 'field', name: 'Mathew Leckie')

# bel, http://en.wikipedia.org/wiki/Belgium_national_football_team#Current_squad
Player.create!(team: bel, position: 'goalkeeper', name: 'Thibaut Courtois')
Player.create!(team: bel, position: 'goalkeeper', name: 'Simon Mignolet')
Player.create!(team: bel, position: 'goalkeeper', name: 'Koen Casteels')
Player.create!(team: bel, position: 'field', name: 'Toby Alderweireld')
Player.create!(team: bel, position: 'field', name: 'Daniel Van Buyten')
Player.create!(team: bel, position: 'field', name: 'Vincent Kompany')
Player.create!(team: bel, position: 'field', name: 'Jan Vertonghen')
Player.create!(team: bel, position: 'field', name: 'Sébastien Pocognoli')
Player.create!(team: bel, position: 'field', name: 'Anthony Vanden Borre')
Player.create!(team: bel, position: 'field', name: 'Nicolas Lombaerts')
Player.create!(team: bel, position: 'field', name: 'Laurent Ciman')
Player.create!(team: bel, position: 'field', name: 'Axel Witsel')
Player.create!(team: bel, position: 'field', name: 'Kevin De Bruyne')
Player.create!(team: bel, position: 'field', name: 'Marouane Fellaini')
Player.create!(team: bel, position: 'field', name: 'Eden Hazard')
Player.create!(team: bel, position: 'field', name: 'Kevin Mirallas')
Player.create!(team: bel, position: 'field', name: 'Radja Nainggolan')
Player.create!(team: bel, position: 'field', name: 'Dries Mertens')
Player.create!(team: bel, position: 'field', name: 'Timmy Simons')
Player.create!(team: bel, position: 'field', name: 'Mousa Dembélé')
Player.create!(team: bel, position: 'field', name: 'Nacer Chadli')
Player.create!(team: bel, position: 'field', name: 'Christian Benteke')
Player.create!(team: bel, position: 'field', name: 'Romelu Lukaku')

# bih, http://en.wikipedia.org/wiki/Bosnia_and_Herzegovina_national_football_team#Current_squad
Player.create!(team: bih, position: 'goalkeeper', name: 'Asmir Begović')
Player.create!(team: bih, position: 'goalkeeper', name: 'Asmir Avdukić')
Player.create!(team: bih, position: 'goalkeeper', name: 'Jasmin Fejzić')
Player.create!(team: bih, position: 'field', name: 'Emir Spahić')
Player.create!(team: bih, position: 'field', name: 'Mensur Mujdža')
Player.create!(team: bih, position: 'field', name: 'Avdija Vršajević')
Player.create!(team: bih, position: 'field', name: 'Ognjen Vranješ')
Player.create!(team: bih, position: 'field', name: 'Ermin Bičakčić')
Player.create!(team: bih, position: 'field', name: 'Muhamed Bešić')
Player.create!(team: bih, position: 'field', name: 'Ervin Zukanović')
Player.create!(team: bih, position: 'field', name: 'Toni Šunjić')
Player.create!(team: bih, position: 'field', name: 'Sead Kolašinac')
Player.create!(team: bih, position: 'field', name: 'Zvjezdan Misimović')
Player.create!(team: bih, position: 'field', name: 'Miralem Pjanić')
Player.create!(team: bih, position: 'field', name: 'Senijad Ibričić')
Player.create!(team: bih, position: 'field', name: 'Sejad Salihović')
Player.create!(team: bih, position: 'field', name: 'Haris Medunjanin')
Player.create!(team: bih, position: 'field', name: 'Senad Lulić')
Player.create!(team: bih, position: 'field', name: 'Edin Višća')
Player.create!(team: bih, position: 'field', name: 'Izet Hajrović')
Player.create!(team: bih, position: 'field', name: 'Tino-Sven Sušić')
Player.create!(team: bih, position: 'field', name: 'Anel Hadžić')
Player.create!(team: bih, position: 'field', name: 'Edin Džeko')
Player.create!(team: bih, position: 'field', name: 'Vedad Ibišević')

# bra, http://en.wikipedia.org/wiki/Brazil_national_football_team#Current_squad
Player.create!(team: bra, position: 'goalkeeper', name: 'Jefferson')
Player.create!(team: bra, position: 'goalkeeper', name: 'Júlio César')
Player.create!(team: bra, position: 'goalkeeper', name: 'Victor')
Player.create!(team: bra, position: 'field', name: 'Dani Alves')
Player.create!(team: bra, position: 'field', name: 'Thiago Silva')
Player.create!(team: bra, position: 'field', name: 'David Luiz')
Player.create!(team: bra, position: 'field', name: 'Marcelo')
Player.create!(team: bra, position: 'field', name: 'Dante')
Player.create!(team: bra, position: 'field', name: 'Maxwell')
Player.create!(team: bra, position: 'field', name: 'Maicon')
Player.create!(team: bra, position: 'field', name: 'Henrique')
Player.create!(team: bra, position: 'field', name: 'Fernandinho')
Player.create!(team: bra, position: 'field', name: 'Ramires')
Player.create!(team: bra, position: 'field', name: 'Hernanes')
Player.create!(team: bra, position: 'field', name: 'Oscar')
Player.create!(team: bra, position: 'field', name: 'Luiz Gustavo')
Player.create!(team: bra, position: 'field', name: 'Paulinho')
Player.create!(team: bra, position: 'field', name: 'Bernard')
Player.create!(team: bra, position: 'field', name: 'Willian')
Player.create!(team: bra, position: 'field', name: 'Fred')
Player.create!(team: bra, position: 'field', name: 'Neymar')
Player.create!(team: bra, position: 'field', name: 'Hulk')
Player.create!(team: bra, position: 'field', name: 'Jô')

# chi, http://en.wikipedia.org/wiki/Chile_national_football_team#Current_squad
Player.create!(team: chi, position: 'goalkeeper', name: 'Johnny Herrera')
Player.create!(team: chi, position: 'goalkeeper', name: 'Cristopher Toselli')
Player.create!(team: chi, position: 'goalkeeper', name: 'Paulo Garcés')
Player.create!(team: chi, position: 'field', name: 'Gonzalo Jara')
Player.create!(team: chi, position: 'field', name: 'Gary Medel')
Player.create!(team: chi, position: 'field', name: 'Mauricio Isla')
Player.create!(team: chi, position: 'field', name: 'Marcos González')
Player.create!(team: chi, position: 'field', name: 'Eugenio Mena')
Player.create!(team: chi, position: 'field', name: 'José Rojas')
Player.create!(team: chi, position: 'field', name: 'Osvaldo González')
Player.create!(team: chi, position: 'field', name: 'Matías Fernández')
Player.create!(team: chi, position: 'field', name: 'Jean Beausejour')
Player.create!(team: chi, position: 'field', name: 'Jorge Valdivia')
Player.create!(team: chi, position: 'field', name: 'Arturo Vidal')
Player.create!(team: chi, position: 'field', name: 'Carlos Carmona')
Player.create!(team: chi, position: 'field', name: 'Fabián Orellana')
Player.create!(team: chi, position: 'field', name: 'José Pedro Fuenzalida')
Player.create!(team: chi, position: 'field', name: 'Charles Aránguiz')
Player.create!(team: chi, position: 'field', name: 'Felipe Gutiérrez')
Player.create!(team: chi, position: 'field', name: 'Francisco Silva')
Player.create!(team: chi, position: 'field', name: 'Alexis Sánchez')
Player.create!(team: chi, position: 'field', name: 'Eduardo Vargas')
Player.create!(team: chi, position: 'field', name: 'Mauricio Pinilla')

# civ, http://en.wikipedia.org/wiki/Ivory_Coast_national_football_team#Current_squad
Player.create!(team: civ, position: 'goalkeeper', name: 'Boubacar Barry')
Player.create!(team: civ, position: 'goalkeeper', name: 'Sayouba Mandé')
Player.create!(team: civ, position: 'goalkeeper', name: 'Sylvain Gbohouo')
Player.create!(team: civ, position: 'field', name: 'Didier Zokora')
Player.create!(team: civ, position: 'field', name: 'Kolo Touré')
Player.create!(team: civ, position: 'field', name: 'Siaka Tiéné')
Player.create!(team: civ, position: 'field', name: 'Arthur Boka')
Player.create!(team: civ, position: 'field', name: 'Serge Aurier')
Player.create!(team: civ, position: 'field', name: 'Brice Dja Djédjé')
Player.create!(team: civ, position: 'field', name: 'Constant Djakpa')
Player.create!(team: civ, position: 'field', name: 'Ousmane Viera')
Player.create!(team: civ, position: 'field', name: 'Jean-Daniel Akpa-Akpro')
Player.create!(team: civ, position: 'field', name: 'Yaya Touré')
Player.create!(team: civ, position: 'field', name: 'Romaric')
Player.create!(team: civ, position: 'field', name: 'Cheick Tioté')
Player.create!(team: civ, position: 'field', name: 'Max Gradel')
Player.create!(team: civ, position: 'field', name: 'Jean-Jacques Gosso')
Player.create!(team: civ, position: 'field', name: 'Serey Die')
Player.create!(team: civ, position: 'field', name: 'Mathis Bolly')
Player.create!(team: civ, position: 'field', name: 'Ismaël Diomande')
Player.create!(team: civ, position: 'field', name: 'Jean Seri')
Player.create!(team: civ, position: 'field', name: 'Didier Drogba')
Player.create!(team: civ, position: 'field', name: 'Salomon Kalou')
Player.create!(team: civ, position: 'field', name: 'Gervinho')
Player.create!(team: civ, position: 'field', name: 'Wilfried Bony')
Player.create!(team: civ, position: 'field', name: 'Seydou Doumbia')
Player.create!(team: civ, position: 'field', name: 'Giovanni Sio')

# cmr, http://en.wikipedia.org/wiki/Cameroon_national_football_team#Current_squad
Player.create!(team: cmr, position: 'goalkeeper', name: "Guy N'dy Assembé")
Player.create!(team: cmr, position: 'goalkeeper', name: 'Charles Itandje')
Player.create!(team: cmr, position: 'goalkeeper', name: "Sammy N'Djock")
Player.create!(team: cmr, position: 'field', name: "Nicolas N'Koulou")
Player.create!(team: cmr, position: 'field', name: 'Aurélien Chedjou')
Player.create!(team: cmr, position: 'field', name: 'Henri Bedimo')
Player.create!(team: cmr, position: 'field', name: 'Benoit Assou-Ekotto')
Player.create!(team: cmr, position: 'field', name: 'Dany Nounkeu')
Player.create!(team: cmr, position: 'field', name: 'Gaëtan Bong')
Player.create!(team: cmr, position: 'field', name: 'Allan Nyom')
Player.create!(team: cmr, position: 'field', name: 'Jean-Armel Kana-Biyik')
Player.create!(team: cmr, position: 'field', name: 'Frank Bagnack')
Player.create!(team: cmr, position: 'field', name: 'Jean Makoun')
Player.create!(team: cmr, position: 'field', name: 'Alex Song')
Player.create!(team: cmr, position: 'field', name: "Landry N'Guémo")
Player.create!(team: cmr, position: 'field', name: 'Eyong Enoh')
Player.create!(team: cmr, position: 'field', name: 'Joël Matip')
Player.create!(team: cmr, position: 'field', name: "Samuel Eto'o")
Player.create!(team: cmr, position: 'field', name: 'Mohammadou Idrissou')
Player.create!(team: cmr, position: 'field', name: 'Maxim Choupo-Moting')
Player.create!(team: cmr, position: 'field', name: 'Vincent Aboubakar')
Player.create!(team: cmr, position: 'field', name: 'Benjamin Moukandjo')
Player.create!(team: cmr, position: 'field', name: 'Jean Marie Dongou')

# col, http://en.wikipedia.org/wiki/Colombia_national_football_team#Current_squad
Player.create!(team: col, position: 'goalkeeper', name: 'Faryd Mondragón')
Player.create!(team: col, position: 'goalkeeper', name: 'David Ospina')
Player.create!(team: col, position: 'goalkeeper', name: 'Camilo Vargas')
Player.create!(team: col, position: 'field', name: 'Mario Yepes')
Player.create!(team: col, position: 'field', name: 'Luis Amaranto Perea')
Player.create!(team: col, position: 'field', name: 'Pablo Armero')
Player.create!(team: col, position: 'field', name: 'Cristián Zapata')
Player.create!(team: col, position: 'field', name: 'Santiago Arias')
Player.create!(team: col, position: 'field', name: 'Stefan Medina')
Player.create!(team: col, position: 'field', name: 'Éder Álvarez Balanta')
Player.create!(team: col, position: 'field', name: 'Fredy Guarín')
Player.create!(team: col, position: 'field', name: 'Abel Aguilar')
Player.create!(team: col, position: 'field', name: 'Carlos Sánchez')
Player.create!(team: col, position: 'field', name: 'Macnelly Torres')
Player.create!(team: col, position: 'field', name: 'Aldo Leão Ramírez')
Player.create!(team: col, position: 'field', name: 'Juan Guillermo Cuadrado')
Player.create!(team: col, position: 'field', name: 'James Rodríguez')
Player.create!(team: col, position: 'field', name: 'Edwin Valencia')
Player.create!(team: col, position: 'field', name: 'Alexander Mejía')
Player.create!(team: col, position: 'field', name: 'Víctor Ibarbo')
Player.create!(team: col, position: 'field', name: 'Juan Fernando Quintero')
Player.create!(team: col, position: 'field', name: 'Teófilo Gutiérrez')
Player.create!(team: col, position: 'field', name: 'Jackson Martínez')
Player.create!(team: col, position: 'field', name: 'Adrián Ramos')
Player.create!(team: col, position: 'field', name: 'Carlos Bacca')
Player.create!(team: col, position: 'field', name: 'Luis Muriel')

# crc, http://en.wikipedia.org/wiki/Costa_rica_national_football_team#Current_squad
Player.create!(team: crc, position: 'goalkeeper', name: 'Keylor Navas')
Player.create!(team: crc, position: 'goalkeeper', name: 'Patrick Pemberton')
Player.create!(team: crc, position: 'field', name: 'Michael Umaña')
Player.create!(team: crc, position: 'field', name: 'Junior Díaz')
Player.create!(team: crc, position: 'field', name: 'Roy Miller')
Player.create!(team: crc, position: 'field', name: 'Giancarlo González')
Player.create!(team: crc, position: 'field', name: 'José Salvatierra')
Player.create!(team: crc, position: 'field', name: 'Cristian Gamboa')
Player.create!(team: crc, position: 'field', name: 'Óscar Duarte')
Player.create!(team: crc, position: 'field', name: 'Waylon Francis')
Player.create!(team: crc, position: 'field', name: 'Celso Borges')
Player.create!(team: crc, position: 'field', name: 'Christian Bolaños')
Player.create!(team: crc, position: 'field', name: 'Michael Barrantes')
Player.create!(team: crc, position: 'field', name: 'José Miguel Cubero')
Player.create!(team: crc, position: 'field', name: 'Yeltsin Tejeda')
Player.create!(team: crc, position: 'field', name: 'Esteban Granados')
Player.create!(team: crc, position: 'field', name: 'Diego Calvo')
Player.create!(team: crc, position: 'field', name: 'Álvaro Saborío')
Player.create!(team: crc, position: 'field', name: 'Bryan Ruiz')
Player.create!(team: crc, position: 'field', name: 'Joel Campbell')
Player.create!(team: crc, position: 'field', name: 'Marco Ureña')
Player.create!(team: crc, position: 'field', name: 'John Jairo Ruiz')

# cro, http://en.wikipedia.org/wiki/Croatia_national_football_team#Current_squad
Player.create!(team: cro, position: 'goalkeeper', name: 'Stipe Pletikosa')
Player.create!(team: cro, position: 'goalkeeper', name: 'Danijel Subašić')
Player.create!(team: cro, position: 'field', name: 'Darijo Srna')
Player.create!(team: cro, position: 'field', name: 'Vedran Ćorluka')
Player.create!(team: cro, position: 'field', name: 'Ivan Strinić')
Player.create!(team: cro, position: 'field', name: 'Dejan Lovren')
Player.create!(team: cro, position: 'field', name: 'Domagoj Vida')
Player.create!(team: cro, position: 'field', name: 'Gordon Schildenfeld')
Player.create!(team: cro, position: 'field', name: 'Šime Vrsaljko')
Player.create!(team: cro, position: 'field', name: 'Hrvoje Milić')
Player.create!(team: cro, position: 'field', name: 'Luka Modrić')
Player.create!(team: cro, position: 'field', name: 'Ivan Rakitić')
Player.create!(team: cro, position: 'field', name: 'Ognjen Vukojević')
Player.create!(team: cro, position: 'field', name: 'Danijel Pranjić')
Player.create!(team: cro, position: 'field', name: 'Ivan Perišić')
Player.create!(team: cro, position: 'field', name: 'Mateo Kovačić')
Player.create!(team: cro, position: 'field', name: 'Mate Maleš')
Player.create!(team: cro, position: 'field', name: 'Ivica Olić')
Player.create!(team: cro, position: 'field', name: 'Eduardo')
Player.create!(team: cro, position: 'field', name: 'Mario Mandžukić')
Player.create!(team: cro, position: 'field', name: 'Nikica Jelavić')
Player.create!(team: cro, position: 'field', name: 'Ante Rebić')

# ecu, http://en.wikipedia.org/wiki/Ecuador_national_football_team#Current_squad
Player.create!(team: ecu, position: 'goalkeeper', name: 'Máximo Banguera')
Player.create!(team: ecu, position: 'goalkeeper', name: 'Alexander Domínguez')
Player.create!(team: ecu, position: 'goalkeeper', name: 'Adrián Bone')
Player.create!(team: ecu, position: 'field', name: 'Walter Ayoví')
Player.create!(team: ecu, position: 'field', name: 'Jorge Guagua')
Player.create!(team: ecu, position: 'field', name: 'Juan Carlos Paredes')
Player.create!(team: ecu, position: 'field', name: 'Frickson Erazo')
Player.create!(team: ecu, position: 'field', name: 'Gabriel Achilier')
Player.create!(team: ecu, position: 'field', name: 'Óscar Bagüí')
Player.create!(team: ecu, position: 'field', name: 'Cristian Ramírez')
Player.create!(team: ecu, position: 'field', name: 'Segundo Castillo')
Player.create!(team: ecu, position: 'field', name: 'Antonio Valencia (Captain)')
Player.create!(team: ecu, position: 'field', name: 'Luis Saritama')
Player.create!(team: ecu, position: 'field', name: 'Christian Noboa')
Player.create!(team: ecu, position: 'field', name: 'Jefferson Montero')
Player.create!(team: ecu, position: 'field', name: 'João Rojas')
Player.create!(team: ecu, position: 'field', name: 'Renato Ibarra')
Player.create!(team: ecu, position: 'field', name: 'Pedro Quiñónez')
Player.create!(team: ecu, position: 'field', name: 'Fidel Martínez')
Player.create!(team: ecu, position: 'field', name: 'Carlos Gruezo')
Player.create!(team: ecu, position: 'field', name: 'Felipe Caicedo')
Player.create!(team: ecu, position: 'field', name: 'Jaime Ayoví')
Player.create!(team: ecu, position: 'field', name: 'Enner Valencia')
Player.create!(team: ecu, position: 'field', name: 'Armando Wila')

# eng, http://en.wikipedia.org/wiki/England_national_football_team#Current_squad
Player.create!(team: eng, position: 'goalkeeper', name: 'Joe Hart')
Player.create!(team: eng, position: 'goalkeeper', name: 'Ben Foster')
Player.create!(team: eng, position: 'goalkeeper', name: 'Fraser Forster')
Player.create!(team: eng, position: 'goalkeeper', name: 'John Ruddy')
Player.create!(team: eng, position: 'field', name: 'Glen Johnson')
Player.create!(team: eng, position: 'field', name: 'Ashley Cole')
Player.create!(team: eng, position: 'field', name: 'Gary Cahill')
Player.create!(team: eng, position: 'field', name: 'Chris Smalling')
Player.create!(team: eng, position: 'field', name: 'Luke Shaw')
Player.create!(team: eng, position: 'field', name: 'Leighton Baines')
Player.create!(team: eng, position: 'field', name: 'Steven Caulker')
Player.create!(team: eng, position: 'field', name: 'Steven Gerrard')
Player.create!(team: eng, position: 'field', name: 'Jack Wilshere')
Player.create!(team: eng, position: 'field', name: 'Jordan Henderson')
Player.create!(team: eng, position: 'field', name: 'Raheem Sterling')
Player.create!(team: eng, position: 'field', name: 'Michael Carrick')
Player.create!(team: eng, position: 'field', name: 'James Milner')
Player.create!(team: eng, position: 'field', name: 'Frank Lampard')
Player.create!(team: eng, position: 'field', name: 'Ross Barkley')
Player.create!(team: eng, position: 'field', name: 'Tom Cleverley')
Player.create!(team: eng, position: 'field', name: 'Adam Lallana')
Player.create!(team: eng, position: 'field', name: 'Alex Oxlade-Chamberlain')
Player.create!(team: eng, position: 'field', name: 'Andros Townsend')
Player.create!(team: eng, position: 'field', name: 'Daniel Sturridge')
Player.create!(team: eng, position: 'field', name: 'Wayne Rooney')
Player.create!(team: eng, position: 'field', name: 'Rickie Lambert')
Player.create!(team: eng, position: 'field', name: 'Jermain Defoe')
Player.create!(team: eng, position: 'field', name: 'Danny Welbeck')
Player.create!(team: eng, position: 'field', name: 'Jay Rodriguez')

# esp, http://en.wikipedia.org/wiki/Spain_national_football_team#Current_squad
Player.create!(team: esp, position: 'goalkeeper', name: 'Iker Casillas')
Player.create!(team: esp, position: 'goalkeeper', name: 'Pepe Reina')
Player.create!(team: esp, position: 'goalkeeper', name: 'Víctor Valdés')
Player.create!(team: esp, position: 'field', name: 'Sergio Ramos')
Player.create!(team: esp, position: 'field', name: 'Raúl Albiol')
Player.create!(team: esp, position: 'field', name: 'Jordi Alba')
Player.create!(team: esp, position: 'field', name: 'Juanfran')
Player.create!(team: esp, position: 'field', name: 'César Azpilicueta')
Player.create!(team: esp, position: 'field', name: 'Xavi Hernández')
Player.create!(team: esp, position: 'field', name: 'Xabi Alonso')
Player.create!(team: esp, position: 'field', name: 'Andrés Iniesta')
Player.create!(team: esp, position: 'field', name: 'Cesc Fàbregas')
Player.create!(team: esp, position: 'field', name: 'David Silva')
Player.create!(team: esp, position: 'field', name: 'Sergio Busquets')
Player.create!(team: esp, position: 'field', name: 'Santi Cazorla')
Player.create!(team: esp, position: 'field', name: 'Jesús Navas')
Player.create!(team: esp, position: 'field', name: 'Javi Martínez')
Player.create!(team: esp, position: 'field', name: 'Koke')
Player.create!(team: esp, position: 'field', name: 'Thiago Alcântara')
Player.create!(team: esp, position: 'field', name: 'Pedro Rodríguez')
Player.create!(team: esp, position: 'field', name: 'Álvaro Negredo')
Player.create!(team: esp, position: 'field', name: 'Diego Costa')

# fra, http://en.wikipedia.org/wiki/France_national_football_team#Current_squad
Player.create!(team: fra, position: 'goalkeeper', name: 'Hugo Lloris')
Player.create!(team: fra, position: 'goalkeeper', name: 'Steve Mandanda')
Player.create!(team: fra, position: 'goalkeeper', name: 'Stéphane Ruffier')
Player.create!(team: fra, position: 'field', name: 'Mathieu Debuchy')
Player.create!(team: fra, position: 'field', name: 'Patrice Evra')
Player.create!(team: fra, position: 'field', name: 'Raphaël Varane')
Player.create!(team: fra, position: 'field', name: 'Mamadou Sakho')
Player.create!(team: fra, position: 'field', name: 'Bacary Sagna')
Player.create!(team: fra, position: 'field', name: 'Laurent Koscielny')
Player.create!(team: fra, position: 'field', name: 'Eliaquim Mangala')
Player.create!(team: fra, position: 'field', name: 'Lucas Digne')
Player.create!(team: fra, position: 'field', name: 'Yohan Cabaye')
Player.create!(team: fra, position: 'field', name: 'Franck Ribéry')
Player.create!(team: fra, position: 'field', name: 'Mathieu Valbuena')
Player.create!(team: fra, position: 'field', name: 'Antoine Griezmann')
Player.create!(team: fra, position: 'field', name: 'Josuha Guilavogui')
Player.create!(team: fra, position: 'field', name: 'Blaise Matuidi')
Player.create!(team: fra, position: 'field', name: 'Dimitri Payet')
Player.create!(team: fra, position: 'field', name: 'Moussa Sissoko')
Player.create!(team: fra, position: 'field', name: 'Paul Pogba')
Player.create!(team: fra, position: 'field', name: 'Olivier Giroud')
Player.create!(team: fra, position: 'field', name: 'Karim Benzema')
Player.create!(team: fra, position: 'field', name: 'Loïc Rémy')

# ger, http://en.wikipedia.org/wiki/Germany_national_football_team#Current_squad
Player.create!(team: ger, position: 'goalkeeper', name: 'Manuel Neuer')
Player.create!(team: ger, position: 'goalkeeper', name: 'Marc-André ter Stegen')
Player.create!(team: ger, position: 'goalkeeper', name: 'Roman Weidenfeller')
Player.create!(team: ger, position: 'goalkeeper', name: 'Ron-Robert Zieler')
Player.create!(team: ger, position: 'field', name: 'André Hahn')
Player.create!(team: ger, position: 'field', name: 'André Schürrle')
Player.create!(team: ger, position: 'field', name: 'Antonio Rüdiger')
Player.create!(team: ger, position: 'field', name: 'Bastian Schweinsteiger')
Player.create!(team: ger, position: 'field', name: 'Benedikt Höwedes')
Player.create!(team: ger, position: 'field', name: 'Christian Günter')
Player.create!(team: ger, position: 'field', name: 'Christoph Kramer')
Player.create!(team: ger, position: 'field', name: 'Erik Durm')
Player.create!(team: ger, position: 'field', name: 'Julian Draxler')
Player.create!(team: ger, position: 'field', name: 'Jérôme Boateng')
Player.create!(team: ger, position: 'field', name: 'Kevin Großkreutz')
Player.create!(team: ger, position: 'field', name: 'Kevin Volland')
Player.create!(team: ger, position: 'field', name: 'Lars Bender')
Player.create!(team: ger, position: 'field', name: 'Leon Goretzka')
Player.create!(team: ger, position: 'field', name: 'Lukas Podolski')
Player.create!(team: ger, position: 'field', name: 'Marcel Schmelzer')
Player.create!(team: ger, position: 'field', name: 'Marcell Jansen')
Player.create!(team: ger, position: 'field', name: 'Marco Reus')
Player.create!(team: ger, position: 'field', name: 'Mario Götze')
Player.create!(team: ger, position: 'field', name: 'Mats Hummels')
Player.create!(team: ger, position: 'field', name: 'Matthias Ginter')
Player.create!(team: ger, position: 'field', name: 'Max Meyer')
Player.create!(team: ger, position: 'field', name: 'Maximilian Arnold')
Player.create!(team: ger, position: 'field', name: 'Mesut Özil')
Player.create!(team: ger, position: 'field', name: 'Miroslav Klose')
Player.create!(team: ger, position: 'field', name: 'Oliver Sorg')
Player.create!(team: ger, position: 'field', name: 'Per Mertesacker')
Player.create!(team: ger, position: 'field', name: 'Philipp Lahm')
Player.create!(team: ger, position: 'field', name: 'Sami Khedira')
Player.create!(team: ger, position: 'field', name: 'Sebastian Jung')
Player.create!(team: ger, position: 'field', name: 'Sebastian Rudy')
Player.create!(team: ger, position: 'field', name: 'Shkodran Mustafi')
Player.create!(team: ger, position: 'field', name: 'Thomas Müller')
Player.create!(team: ger, position: 'field', name: 'Toni Kroos')

# gha, http://en.wikipedia.org/wiki/Ghana_national_football_team#Current_squad
Player.create!(team: gha, position: 'goalkeeper', name: 'Adam Kwarasey')
Player.create!(team: gha, position: 'goalkeeper', name: 'Steven Adams')
Player.create!(team: gha, position: 'field', name: 'Samuel Inkoom')
Player.create!(team: gha, position: 'field', name: 'Harrison Afful')
Player.create!(team: gha, position: 'field', name: 'John Boye')
Player.create!(team: gha, position: 'field', name: 'Jonathan Mensah')
Player.create!(team: gha, position: 'field', name: 'Daniel Opare')
Player.create!(team: gha, position: 'field', name: 'Jerry Akaminko')
Player.create!(team: gha, position: 'field', name: 'David Addy')
Player.create!(team: gha, position: 'field', name: 'Sulley Muntari')
Player.create!(team: gha, position: 'field', name: 'Kwadwo Asamoah')
Player.create!(team: gha, position: 'field', name: 'Michael Essien')
Player.create!(team: gha, position: 'field', name: 'Emmanuel Agyemang-Badu')
Player.create!(team: gha, position: 'field', name: 'André Ayew')
Player.create!(team: gha, position: 'field', name: 'Christian Atsu')
Player.create!(team: gha, position: 'field', name: 'Wakaso Mubarak')
Player.create!(team: gha, position: 'field', name: 'Albert Adomah')
Player.create!(team: gha, position: 'field', name: 'Kevin-Prince Boateng')
Player.create!(team: gha, position: 'field', name: 'Asamoah Gyan')
Player.create!(team: gha, position: 'field', name: 'Majeed Waris')
Player.create!(team: gha, position: 'field', name: 'Jordan Ayew')

# gre, http://en.wikipedia.org/wiki/Greece_national_football_team#Current_squad
Player.create!(team: gre, position: 'goalkeeper', name: 'Alexandros Tzorvas')
Player.create!(team: gre, position: 'goalkeeper', name: 'Panagiotis Glykos')
Player.create!(team: gre, position: 'field', name: 'Giannis Maniatis')
Player.create!(team: gre, position: 'field', name: 'Giorgos Tzavellas')
Player.create!(team: gre, position: 'field', name: 'Kostas Manolas')
Player.create!(team: gre, position: 'field', name: 'Avraam Papadopoulos')
Player.create!(team: gre, position: 'field', name: 'Loukas Vyntra')
Player.create!(team: gre, position: 'field', name: 'Vasilis Torosidis')
Player.create!(team: gre, position: 'field', name: 'José Holebas')
Player.create!(team: gre, position: 'field', name: 'Alexandros Tziolis')
Player.create!(team: gre, position: 'field', name: 'Giorgos Karagounis (captain)')
Player.create!(team: gre, position: 'field', name: 'Lazaros Christodoulopoulos')
Player.create!(team: gre, position: 'field', name: 'Andreas Samaris')
Player.create!(team: gre, position: 'field', name: 'Kostas Katsouranis')
Player.create!(team: gre, position: 'field', name: 'Giannis Fetfatzidis')
Player.create!(team: gre, position: 'field', name: 'Panagiotis Kone')
Player.create!(team: gre, position: 'field', name: 'Giorgos Samaras')
Player.create!(team: gre, position: 'field', name: 'Kostas Mitroglou')
Player.create!(team: gre, position: 'field', name: 'Dimitris Salpingidis')
Player.create!(team: gre, position: 'field', name: 'Dimitris Papadopoulos')

# hon, http://en.wikipedia.org/wiki/Honduras_national_football_team#Current_squad
Player.create!(team: hon, position: 'goalkeeper', name: 'Noel Valladares')
Player.create!(team: hon, position: 'goalkeeper', name: 'Donis Escober')
Player.create!(team: hon, position: 'goalkeeper', name: 'Luis López')
Player.create!(team: hon, position: 'field', name: 'Maynor Figueroa')
Player.create!(team: hon, position: 'field', name: 'Víctor Bernárdez')
Player.create!(team: hon, position: 'field', name: 'Emilio Izaguirre')
Player.create!(team: hon, position: 'field', name: 'Osman Chávez')
Player.create!(team: hon, position: 'field', name: 'Juan Carlos García')
Player.create!(team: hon, position: 'field', name: 'Brayan Beckeles')
Player.create!(team: hon, position: 'field', name: 'Arnold Peralta')
Player.create!(team: hon, position: 'field', name: 'Juan Pablo Montes')
Player.create!(team: hon, position: 'field', name: 'Wilson Palacios')
Player.create!(team: hon, position: 'field', name: 'Óscar García')
Player.create!(team: hon, position: 'field', name: 'Jorge Claros')
Player.create!(team: hon, position: 'field', name: 'Marvin Chávez')
Player.create!(team: hon, position: 'field', name: 'Roger Espinoza')
Player.create!(team: hon, position: 'field', name: 'Mario Martínez')
Player.create!(team: hon, position: 'field', name: 'Luis Garrido')
Player.create!(team: hon, position: 'field', name: 'Andy Najar')
Player.create!(team: hon, position: 'field', name: 'Carlo Costly')
Player.create!(team: hon, position: 'field', name: 'Jerry Bengtson')
Player.create!(team: hon, position: 'field', name: 'Jerry Palacios')
Player.create!(team: hon, position: 'field', name: 'Rony Martínez')

# irn, http://en.wikipedia.org/wiki/Iran_national_football_team#Current_squad
Player.create!(team: irn, position: 'goalkeeper', name: 'Rahman Ahmadi')
Player.create!(team: irn, position: 'goalkeeper', name: 'Alireza Haghighi')
Player.create!(team: irn, position: 'goalkeeper', name: 'Daniel Davari')
Player.create!(team: irn, position: 'goalkeeper', name: 'Sosha Makani')
Player.create!(team: irn, position: 'field', name: 'Jalal Hosseini')
Player.create!(team: irn, position: 'field', name: 'Ehsan Hajsafi')
Player.create!(team: irn, position: 'field', name: 'Khosro Heydari')
Player.create!(team: irn, position: 'field', name: 'Pejman Montazeri')
Player.create!(team: irn, position: 'field', name: 'Hossein Mahini')
Player.create!(team: irn, position: 'field', name: 'Mehrdad Pooladi')
Player.create!(team: irn, position: 'field', name: 'Hashem Beikzadeh')
Player.create!(team: irn, position: 'field', name: 'Amir Hossein Sadeghi')
Player.create!(team: irn, position: 'field', name: 'Ahmad Alenemeh')
Player.create!(team: irn, position: 'field', name: 'Mohammad Reza Khanzadeh')
Player.create!(team: irn, position: 'field', name: 'Mehrdad Beitashour')
Player.create!(team: irn, position: 'field', name: 'Javad Nekounam (Captain)')
Player.create!(team: irn, position: 'field', name: 'Andranik Teymourian')
Player.create!(team: irn, position: 'field', name: 'Mohammad Reza Khalatbari')
Player.create!(team: irn, position: 'field', name: 'Masoud Shojaei')
Player.create!(team: irn, position: 'field', name: 'Ghasem Haddadifar')
Player.create!(team: irn, position: 'field', name: 'Ashkan Dejagah')
Player.create!(team: irn, position: 'field', name: 'Reza Haghighi')
Player.create!(team: irn, position: 'field', name: 'Alireza Jahanbakhsh')
Player.create!(team: irn, position: 'field', name: 'Bakhtiar Rahmani')
Player.create!(team: irn, position: 'field', name: 'Karim Ansarifard')
Player.create!(team: irn, position: 'field', name: 'Reza Ghoochannejhad')
Player.create!(team: irn, position: 'field', name: 'Sardar Azmoun')
Player.create!(team: irn, position: 'field', name: 'Mehdi Sharifi')

# ita, http://en.wikipedia.org/wiki/Italy_national_football_team#Current_squad
Player.create!(team: ita, position: 'goalkeeper', name: 'Gianluigi Buffon')
Player.create!(team: ita, position: 'goalkeeper', name: 'Salvatore Sirigu')
Player.create!(team: ita, position: 'goalkeeper', name: 'Mattia Perin')
Player.create!(team: ita, position: 'field', name: 'Giorgio Chiellini')
Player.create!(team: ita, position: 'field', name: 'Andrea Barzagli')
Player.create!(team: ita, position: 'field', name: 'Leonardo Bonucci')
Player.create!(team: ita, position: 'field', name: 'Christian Maggio')
Player.create!(team: ita, position: 'field', name: 'Domenico Criscito')
Player.create!(team: ita, position: 'field', name: 'Ignazio Abate')
Player.create!(team: ita, position: 'field', name: 'Mattia De Sciglio')
Player.create!(team: ita, position: 'field', name: 'Davide Astori')
Player.create!(team: ita, position: 'field', name: 'Gabriel Paletta')
Player.create!(team: ita, position: 'field', name: 'Andrea Pirlo')
Player.create!(team: ita, position: 'field', name: 'Riccardo Montolivo')
Player.create!(team: ita, position: 'field', name: 'Claudio Marchisio')
Player.create!(team: ita, position: 'field', name: 'Emanuele Giaccherini')
Player.create!(team: ita, position: 'field', name: 'Thiago Motta')
Player.create!(team: ita, position: 'field', name: 'Antonio Candreva')
Player.create!(team: ita, position: 'field', name: 'Marco Verratti')
Player.create!(team: ita, position: 'field', name: 'Marco Parolo')
Player.create!(team: ita, position: 'field', name: 'Alberto Gilardino')
Player.create!(team: ita, position: 'field', name: 'Pablo Osvaldo')
Player.create!(team: ita, position: 'field', name: 'Alessio Cerci')
Player.create!(team: ita, position: 'field', name: 'Mattia Destro')
Player.create!(team: ita, position: 'field', name: 'Lorenzo Insigne')
Player.create!(team: ita, position: 'field', name: 'Ciro Immobile')
Player.create!(team: ita, position: 'field', name: 'Stephan El Shaarawy')
Player.create!(team: ita, position: 'field', name: 'Mario Balotelli')

# jpn, http://en.wikipedia.org/wiki/Japan_national_football_team#Current_squad
Player.create!(team: jpn, position: 'goalkeeper', name: 'Eiji Kawashima')
Player.create!(team: jpn, position: 'goalkeeper', name: 'Shūsaku Nishikawa')
Player.create!(team: jpn, position: 'goalkeeper', name: 'Shūichi Gonda')
Player.create!(team: jpn, position: 'field', name: 'Yūichi Komano')
Player.create!(team: jpn, position: 'field', name: 'Yasuyuki Konno')
Player.create!(team: jpn, position: 'field', name: 'Yūto Nagatomo')
Player.create!(team: jpn, position: 'field', name: 'Maya Yoshida')
Player.create!(team: jpn, position: 'field', name: 'Masahiko Inoha')
Player.create!(team: jpn, position: 'field', name: 'Hiroki Sakai')
Player.create!(team: jpn, position: 'field', name: 'Gōtoku Sakai')
Player.create!(team: jpn, position: 'field', name: 'Masato Morishige')
Player.create!(team: jpn, position: 'field', name: 'Yasuhito Endō')
Player.create!(team: jpn, position: 'field', name: 'Shinji Kagawa')
Player.create!(team: jpn, position: 'field', name: 'Keisuke Honda')
Player.create!(team: jpn, position: 'field', name: 'Hajime Hosogai')
Player.create!(team: jpn, position: 'field', name: 'Hiroshi Kiyotake')
Player.create!(team: jpn, position: 'field', name: 'Hotaru Yamaguchi')
Player.create!(team: jpn, position: 'field', name: 'Manabu Saitō')
Player.create!(team: jpn, position: 'field', name: 'Toshihiro Aoyama')
Player.create!(team: jpn, position: 'field', name: 'Shinji Okazaki')
Player.create!(team: jpn, position: 'field', name: 'Yūya Ōsako')
Player.create!(team: jpn, position: 'field', name: 'Masato Kudo')
Player.create!(team: jpn, position: 'field', name: 'Yōhei Toyoda')

# kor, http://en.wikipedia.org/wiki/Korea_Republic_national_football_team#Current_squad
Player.create!(team: kor, position: 'goalkeeper', name: 'Jung Sung-Ryong')
Player.create!(team: kor, position: 'goalkeeper', name: 'Kim Seung-Gyu')
Player.create!(team: kor, position: 'goalkeeper', name: 'Lee Bum-Young')
Player.create!(team: kor, position: 'field', name: 'Kwak Tae-Hwi')
Player.create!(team: kor, position: 'field', name: 'Hong Jeong-Ho')
Player.create!(team: kor, position: 'field', name: 'Kim Young-Gwon')
Player.create!(team: kor, position: 'field', name: 'Lee Yong')
Player.create!(team: kor, position: 'field', name: 'Kim Jin-Su')
Player.create!(team: kor, position: 'field', name: 'Kim Chang-Soo')
Player.create!(team: kor, position: 'field', name: 'Hwang Seok-Ho')
Player.create!(team: kor, position: 'field', name: 'Yun Suk-Young')
Player.create!(team: kor, position: 'field', name: 'Ki Sung-Yueng')
Player.create!(team: kor, position: 'field', name: 'Lee Chung-Yong')
Player.create!(team: kor, position: 'field', name: 'Koo Ja-Cheol')
Player.create!(team: kor, position: 'field', name: 'Kim Bo-Kyung')
Player.create!(team: kor, position: 'field', name: 'Ha Dae-Sung')
Player.create!(team: kor, position: 'field', name: 'Park Jong-Woo')
Player.create!(team: kor, position: 'field', name: 'Han Kook-Young')
Player.create!(team: kor, position: 'field', name: 'Park Chu-Young')
Player.create!(team: kor, position: 'field', name: 'Lee Keun-Ho')
Player.create!(team: kor, position: 'field', name: 'Ji Dong-Won')
Player.create!(team: kor, position: 'field', name: 'Kim Shin-Wook')
Player.create!(team: kor, position: 'field', name: 'Son Heung-Min')

# mex, http://en.wikipedia.org/wiki/Mexico_national_football_team#Current_squad
Player.create!(team: mex, position: 'goalkeeper', name: 'Guillermo Ochoa')
Player.create!(team: mex, position: 'goalkeeper', name: 'José de Jesús Corona')
Player.create!(team: mex, position: 'goalkeeper', name: 'Alfredo Talavera')
Player.create!(team: mex, position: 'field', name: 'Carlos Salcido')
Player.create!(team: mex, position: 'field', name: 'Rafael Márquez')
Player.create!(team: mex, position: 'field', name: 'Andrés Guardado')
Player.create!(team: mex, position: 'field', name: 'Francisco Javier Rodríguez')
Player.create!(team: mex, position: 'field', name: 'Héctor Moreno')
Player.create!(team: mex, position: 'field', name: 'Paul Aguilar')
Player.create!(team: mex, position: 'field', name: 'Diego Reyes')
Player.create!(team: mex, position: 'field', name: 'Miguel Layún')
Player.create!(team: mex, position: 'field', name: 'Carlos Peña')
Player.create!(team: mex, position: 'field', name: 'Marco Fabián')
Player.create!(team: mex, position: 'field', name: 'Luis Montes')
Player.create!(team: mex, position: 'field', name: 'Héctor Herrera')
Player.create!(team: mex, position: 'field', name: 'Juan Carlos Medina')
Player.create!(team: mex, position: 'field', name: 'Isaác Brizuela')
Player.create!(team: mex, position: 'field', name: 'José Juan Vázquez')
Player.create!(team: mex, position: 'field', name: 'Giovani dos Santos')
Player.create!(team: mex, position: 'field', name: 'Javier Hernández')
Player.create!(team: mex, position: 'field', name: 'Oribe Peralta')
Player.create!(team: mex, position: 'field', name: 'Raúl Jiménez')
Player.create!(team: mex, position: 'field', name: 'Alan Pulido')

# ned, http://en.wikipedia.org/wiki/Netherlands_national_football_team#Current_squad
Player.create!(team: ned, position: 'goalkeeper', name: 'Jasper Cillessen')
Player.create!(team: ned, position: 'goalkeeper', name: 'Kenneth Vermeer')
Player.create!(team: ned, position: 'goalkeeper', name: 'Jeroen Zoet')
Player.create!(team: ned, position: 'field', name: 'Bruno Martins Indi')
Player.create!(team: ned, position: 'field', name: 'Daryl Janmaat')
Player.create!(team: ned, position: 'field', name: 'Stefan de Vrij')
Player.create!(team: ned, position: 'field', name: 'Karim Rekik')
Player.create!(team: ned, position: 'field', name: 'Joël Veltman')
Player.create!(team: ned, position: 'field', name: 'Terence Kongolo')
Player.create!(team: ned, position: 'field', name: 'Daley Blind')
Player.create!(team: ned, position: 'field', name: 'Luciano Narsingh')
Player.create!(team: ned, position: 'field', name: 'Jordy Clasie')
Player.create!(team: ned, position: 'field', name: 'Memphis Depay')
Player.create!(team: ned, position: 'field', name: 'Georginio Wijnaldum')
Player.create!(team: ned, position: 'field', name: 'Marco van Ginkel')
Player.create!(team: ned, position: 'field', name: 'Jean-Paul Boëtius')
Player.create!(team: ned, position: 'field', name: 'Davy Klaassen')
Player.create!(team: ned, position: 'field', name: 'Quincy Promes')
Player.create!(team: ned, position: 'field', name: 'Tonny Vilhena')
Player.create!(team: ned, position: 'field', name: 'Luc Castaignos')

# nga, http://en.wikipedia.org/wiki/Nigeria_national_football_team#Current_squad
Player.create!(team: nga, position: 'goalkeeper', name: 'Vincent Enyeama')
Player.create!(team: nga, position: 'goalkeeper', name: 'Austin Ejide')
Player.create!(team: nga, position: 'goalkeeper', name: 'Chigozie Agbim')
Player.create!(team: nga, position: 'goalkeeper', name: 'Daniel Akpeyi')
Player.create!(team: nga, position: 'field', name: 'Joseph Yobo')
Player.create!(team: nga, position: 'field', name: 'Elderson')
Player.create!(team: nga, position: 'field', name: 'Efe Ambrose')
Player.create!(team: nga, position: 'field', name: 'Godfrey Oboabona')
Player.create!(team: nga, position: 'field', name: 'Azubuike Egwuekwe')
Player.create!(team: nga, position: 'field', name: 'Kenneth Omeruo')
Player.create!(team: nga, position: 'field', name: 'Juwon Oshaniwa')
Player.create!(team: nga, position: 'field', name: 'Kunle Odunlami')
Player.create!(team: nga, position: 'field', name: 'John Obi Mikel')
Player.create!(team: nga, position: 'field', name: 'Ahmed Musa')
Player.create!(team: nga, position: 'field', name: 'Ejike Uzoenyi')
Player.create!(team: nga, position: 'field', name: 'Ogenyi Onazi')
Player.create!(team: nga, position: 'field', name: 'Victor Moses')
Player.create!(team: nga, position: 'field', name: 'Sunday Mba')
Player.create!(team: nga, position: 'field', name: 'Nnamdi Oduamadi')
Player.create!(team: nga, position: 'field', name: 'Joel Obi')
Player.create!(team: nga, position: 'field', name: 'Nosa Igiebor')
Player.create!(team: nga, position: 'field', name: 'Reuben Gabriel')
Player.create!(team: nga, position: 'field', name: 'Michel Babatunde')
Player.create!(team: nga, position: 'field', name: 'Ramon Azeez')
Player.create!(team: nga, position: 'field', name: 'Peter Odemwingie')
Player.create!(team: nga, position: 'field', name: 'Victor Obinna')
Player.create!(team: nga, position: 'field', name: 'Emmanuel Emenike')
Player.create!(team: nga, position: 'field', name: 'Shola Ameobi')
Player.create!(team: nga, position: 'field', name: 'Uche Nwofor')
Player.create!(team: nga, position: 'field', name: 'Michael Uchebo')

# por, http://en.wikipedia.org/wiki/Portugal_national_football_team#Current_squad
Player.create!(team: por, position: 'goalkeeper', name: 'Eduardo')
Player.create!(team: por, position: 'goalkeeper', name: 'Beto')
Player.create!(team: por, position: 'goalkeeper', name: 'Anthony Lopes')
Player.create!(team: por, position: 'field', name: 'Rolando')
Player.create!(team: por, position: 'field', name: 'Pepe')
Player.create!(team: por, position: 'field', name: 'Fábio Coentrão')
Player.create!(team: por, position: 'field', name: 'Ricardo Costa')
Player.create!(team: por, position: 'field', name: 'Luís Neto')
Player.create!(team: por, position: 'field', name: 'Vitorino Antunes')
Player.create!(team: por, position: 'field', name: 'João Pereira')
Player.create!(team: por, position: 'field', name: 'Miguel Lopes')
Player.create!(team: por, position: 'field', name: 'Miguel Veloso')
Player.create!(team: por, position: 'field', name: 'William Carvalho')
Player.create!(team: por, position: 'field', name: 'João Moutinho')
Player.create!(team: por, position: 'field', name: 'Josué')
Player.create!(team: por, position: 'field', name: 'Rafa Silva')
Player.create!(team: por, position: 'field', name: 'Raul Meireles')
Player.create!(team: por, position: 'field', name: 'Silvestre Varela')
Player.create!(team: por, position: 'field', name: 'Rúben Amorim')
Player.create!(team: por, position: 'field', name: 'Cristiano Ronaldo')
Player.create!(team: por, position: 'field', name: 'Hugo Almeida')
Player.create!(team: por, position: 'field', name: 'Edinho')
Player.create!(team: por, position: 'field', name: 'Ivan Cavaleiro')

# rus, http://en.wikipedia.org/wiki/Russia_national_football_team#Current_squad
Player.create!(team: rus, position: 'goalkeeper', name: 'Igor Akinfeev')
Player.create!(team: rus, position: 'goalkeeper', name: 'Yuri Lodygin')
Player.create!(team: rus, position: 'goalkeeper', name: 'Sergey Ryzhikov')
Player.create!(team: rus, position: 'field', name: 'Sergei Ignashevich')
Player.create!(team: rus, position: 'field', name: 'Vasili Berezutski')
Player.create!(team: rus, position: 'field', name: 'Dmitri Kombarov')
Player.create!(team: rus, position: 'field', name: 'Andrey Yeshchenko')
Player.create!(team: rus, position: 'field', name: 'Aleksei Kozlov')
Player.create!(team: rus, position: 'field', name: 'Vladimir Granat')
Player.create!(team: rus, position: 'field', name: 'Georgi Schennikov')
Player.create!(team: rus, position: 'field', name: 'Yevgeni Makeyev')
Player.create!(team: rus, position: 'field', name: 'Maksim Belyayev')
Player.create!(team: rus, position: 'field', name: 'Yuri Zhirkov')
Player.create!(team: rus, position: 'field', name: 'Roman Shirokov')
Player.create!(team: rus, position: 'field', name: 'Igor Denisov')
Player.create!(team: rus, position: 'field', name: 'Alan Dzagoev')
Player.create!(team: rus, position: 'field', name: 'Denis Glushakov')
Player.create!(team: rus, position: 'field', name: 'Viktor Fayzulin')
Player.create!(team: rus, position: 'field', name: 'Aleksandr Samedov')
Player.create!(team: rus, position: 'field', name: 'Aleksandr Ryazantsev')
Player.create!(team: rus, position: 'field', name: 'Oleg Shatov')
Player.create!(team: rus, position: 'field', name: 'Aleksei Ionov')
Player.create!(team: rus, position: 'field', name: 'Aleksandr Kerzhakov')
Player.create!(team: rus, position: 'field', name: 'Aleksandr Kokorin')
Player.create!(team: rus, position: 'field', name: 'Fyodor Smolov')

# sui, http://en.wikipedia.org/wiki/Switzerland_national_football_team#Current_squad
Player.create!(team: sui, position: 'goalkeeper', name: 'Diego Benaglio')
Player.create!(team: sui, position: 'goalkeeper', name: 'Yann Sommer')
Player.create!(team: sui, position: 'field', name: 'Stephan Lichtsteiner')
Player.create!(team: sui, position: 'field', name: 'Philippe Senderos')
Player.create!(team: sui, position: 'field', name: 'Johan Djourou')
Player.create!(team: sui, position: 'field', name: 'Steve von Bergen')
Player.create!(team: sui, position: 'field', name: 'Ricardo Rodríguez')
Player.create!(team: sui, position: 'field', name: 'Michael Lang')
Player.create!(team: sui, position: 'field', name: 'Tranquillo Barnetta')
Player.create!(team: sui, position: 'field', name: 'Gökhan İnler (captain)')
Player.create!(team: sui, position: 'field', name: 'Gelson Fernandes')
Player.create!(team: sui, position: 'field', name: 'Valon Behrami')
Player.create!(team: sui, position: 'field', name: 'Blerim Džemaili')
Player.create!(team: sui, position: 'field', name: 'Xherdan Shaqiri')
Player.create!(team: sui, position: 'field', name: 'Granit Xhaka')
Player.create!(team: sui, position: 'field', name: 'Valentin Stocker')
Player.create!(team: sui, position: 'field', name: 'Pirmin Schwegler')
Player.create!(team: sui, position: 'field', name: 'Admir Mehmedi')
Player.create!(team: sui, position: 'field', name: 'Mario Gavranović')
Player.create!(team: sui, position: 'field', name: 'Haris Seferović')
Player.create!(team: sui, position: 'field', name: 'Josip Drmić')

# uru, http://en.wikipedia.org/wiki/Uruguay_national_football_team#Current_squad
# http://globoesporte.globo.com/futebol/copa-do-mundo/noticia/2014/05/uruguai-divulga-lista-para-copa-com-25-nomes-e-quatro-brasileiros.html
Player.create!(team: uru, position: 'goalkeeper', name: 'Fernando Muslera')
Player.create!(team: uru, position: 'goalkeeper', name: 'Martín Silva')
Player.create!(team: uru, position: 'goalkeeper', name: 'Rodrigo Muñoz')
Player.create!(team: uru, position: 'field', name: 'Diego Lugano')
Player.create!(team: uru, position: 'field', name: 'Diego Godín')
Player.create!(team: uru, position: 'field', name: 'José María Giménez')
Player.create!(team: uru, position: 'field', name: 'Martín Cáceres')
Player.create!(team: uru, position: 'field', name: 'Maxi Pereira')
Player.create!(team: uru, position: 'field', name: 'Jorge Fucile')
Player.create!(team: uru, position: 'field', name: 'Sebástian Coates')
Player.create!(team: uru, position: 'field', name: 'Arévalo Ríos')
Player.create!(team: uru, position: 'field', name: 'Walter Gargano')
Player.create!(team: uru, position: 'field', name: 'Alejandro Silva')
Player.create!(team: uru, position: 'field', name: 'Gastón Ramírez')
Player.create!(team: uru, position: 'field', name: 'Cristian Rodríguez')
Player.create!(team: uru, position: 'field', name: 'Nicolás Lodeiro')
Player.create!(team: uru, position: 'field', name: 'Sebastián Eguren')
Player.create!(team: uru, position: 'field', name: 'Álvaro González')
Player.create!(team: uru, position: 'field', name: 'Álvaro Pereira')
Player.create!(team: uru, position: 'field', name: 'Edinson Cavani')
Player.create!(team: uru, position: 'field', name: 'Luis Suárez')
Player.create!(team: uru, position: 'field', name: 'Diego Forlán')
Player.create!(team: uru, position: 'field', name: 'Abel Hernández')
Player.create!(team: uru, position: 'field', name: 'Cristian Stuani')

# usa, http://en.wikipedia.org/wiki/United_States_men%27s_national_soccer_team#Current_squad
Player.create!(team: usa, position: 'goalkeeper', name: 'Nick Rimando')
Player.create!(team: usa, position: 'goalkeeper', name: 'Sean Johnson')
Player.create!(team: usa, position: 'goalkeeper', name: 'Bill Hamid')
Player.create!(team: usa, position: 'field', name: 'DeAndre Yedlin')
Player.create!(team: usa, position: 'field', name: 'Omar Gonzalez')
Player.create!(team: usa, position: 'field', name: 'Matt Besler')
Player.create!(team: usa, position: 'field', name: 'Tony Beltran')
Player.create!(team: usa, position: 'field', name: 'Michael Parkhurst')
Player.create!(team: usa, position: 'field', name: 'Clarence Goodson')
Player.create!(team: usa, position: 'field', name: 'Michael Bradley')
Player.create!(team: usa, position: 'field', name: 'Maurice Edu')
Player.create!(team: usa, position: 'field', name: 'Landon Donovan')
Player.create!(team: usa, position: 'field', name: 'Brad Davis')
Player.create!(team: usa, position: 'field', name: 'Kyle Beckerman')
Player.create!(team: usa, position: 'field', name: 'Luis Gil')
Player.create!(team: usa, position: 'field', name: 'Graham Zusi')
Player.create!(team: usa, position: 'field', name: 'Clint Dempsey')
Player.create!(team: usa, position: 'field', name: 'Julian Green')
Player.create!(team: usa, position: 'field', name: 'Chris Wondolowski')
Player.create!(team: usa, position: 'field', name: 'Eddie Johnson')

# Suggested questions
Question.create!(
  number: 1,
  body_en: 'Which team will be the champion?',
  body_pt: 'Que país será o campeão?',
  played_at: m01.played_at,
  answer_type: 'team')
Question.create!(
  number: 2,
  body_en: 'Which team will come in second place?',
  body_pt: 'Que país será o vice-campeão?',
  played_at: m01.played_at,
  answer_type: 'team')
Question.create!(
  number: 3,
  body_en: 'Which team will come in third place?',
  body_pt: 'Que país será o terceiro lugar?',
  played_at: m01.played_at,
  answer_type: 'team')
Question.create!(
  number: 4,
  body_en: 'Which player will score the most goals (Golden Foot trophy)?',
  body_pt: 'Quem será artilheiro (troféu Chuteira de Ouro)?',
  played_at: m01.played_at,
  answer_scope: "players.position='field'",
  answer_type: 'player')
Question.create!(
  number: 5,
  body_en: 'Which player will be the best goalkeeper (Golden Glove trophy)?',
  body_pt: 'Quem será melhor goleiro (troféu Luva de Ouro)?',
  played_at: m01.played_at,
  answer_scope: "players.position='goalkeeper'",
  answer_type: 'player')
Question.create!(
  number: 6,
  body_en: 'Which player will be the best (Golden Ball trophy)?',
  body_pt: 'Quem será melhor jogador (troféu Bola de Ouro)?',
  played_at: m01.played_at,
  answer_type: 'player')
Question.create!(
  number: 7,
  body_en: 'Which player will be the second best (Silver Ball trophy)?',
  body_pt: 'Quem será melhor segundo jogador (troféu Bola de Prata)?',
  played_at: m01.played_at,
  answer_type: 'player')
Question.create!(
  number: 8,
  body_en: 'Which player will be the third best (Bronze Ball trophy)?',
  body_pt: 'Quem será melhor terceiro jogador (troféu Bola de Bronze)?',
  played_at: m01.played_at,
  answer_type: 'player')
Question.create!(
  number: 9,
  body_en: 'Which team will make the fewer fouls and receive the fewer cards (Fair Play trophy)?',
  body_pt: 'Que país terá menos faltas e cartões (troféu Fair Play)?',
  played_at: m01.played_at,
  answer_type: 'team')
Question.create!(
  number: 10,
  body_en: 'Will there be any game with field invasion by fans?',
  body_pt: 'Haverá algum jogo com campo invadido por torcedores?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 11,
  body_en: 'Will some fan show her boobs inside a stadium on TV or photo?',
  body_pt: 'Alguma torcedora vai mostrar os seios no estádio na TV ou foto?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 12,
  body_en: 'Will some player from Brazil score an own goal?',
  body_pt: 'Algum jogador do Brasil vai marcar gol contra?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 13,
  body_en: 'Will there be any fight betweern players and/or referees in any game?',
  body_pt: 'Haverá briga em campo entre jogadores e/ou árbitros em algum jogo?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 14,
  body_en: 'Will there be any fighting among fans in the stadiums?',
  body_pt: 'Haverá briga na arquibancada em algum jogo?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 15,
  body_en: 'Will there be any protesting against the world cup or FIFA in the opening or closing ceremonies?',
  body_pt: 'Haverá protesto #NãoVaiTerCopa ou #ForaFIFA nas cerimônias de abertura ou encerramento?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 16,
  body_en: 'Will someone throw a banana on the field in any game?',
  body_pt: 'Alguém vai jogar uma banana no gramado em algum jogo?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 17,
  body_en: 'Will Brazil be benefited by a penalty after a clear simulation from Neymar?',
  body_pt: 'O Brasil será beneficiado por um pênalty após uma clara simulação do Neymar?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 18,
  body_en: 'Will any player from Brazil receive a red card in any match?',
  body_pt: 'Algum jogador do Brasil vai ser expulso em algum jogo?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 19,
  body_en: 'Will Galvão Bueno cry live on TV during the broadcast of any game?',
  body_pt: 'O Galvão Bueno vai chorar ao vivo durante a transmissão de algum jogo?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 20,
  body_en: 'Will Big Phil curse a jornalist?',
  body_pt: 'O Felipão vai xingar algum jornalista?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 21,
  body_en: 'Will Spain be eliminated on the group phase?',
  body_pt: 'A Espanha vai dar vexame e ser eliminada na fase de grupos?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 22,
  body_en: 'Will any asian team get to the quater-finals?',
  body_pt: 'Algum time asiático chegará às quartas-de-final?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 23,
  body_en: 'Will any african team get to the semi-finals?',
  body_pt: 'Algum time africano chegará às semi-finais?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 24,
  body_en: 'Will the champion be a first time winner?',
  body_pt: 'O campeão será inédito?',
  played_at: m01.played_at,
  answer_type: 'boolean')
Question.create!(
  number: 25,
  body_en: 'Which player will score the first goal for Brazil?',
  body_pt: 'Qual jogador marcará o primeiro gol do Brasil?',
  played_at: m01.played_at,
  answer_scope: "players.team_id=#{bra.id}",
  answer_type: 'player')
