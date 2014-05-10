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
