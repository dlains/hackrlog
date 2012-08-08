#!/usr/bin/env ruby

require 'faker'
require 'bcrypt'

FILL_FILE = 'fill.sql'
TAG_WORDS = [
  'crescent','mediation','suggestible','toy','arrogance','impious','astonish','island','gum','subplot','kebab','locker','optometrist','strife','vector','articulate','highfalutin','two-faced','skywriting','corny','john',
  'precious','fiche','shortstop','mumps','double_standard','bloat','saxophone','whose','handsome','operetta','lemony','crack','scud','industrialize','radar','twain','alas','battering_ram','omission','appositive','musical',
  'empathy','tune','municipality','crocodile','gas_station','microbiology','underclass','teapot','ironclad','catching','flighty','uncommitted','storage_battery','catfish','spider','stringency','menu','minuteman','candor','ban',
  'behavior','matriarch','entity','VDT','RAM','absorbent','heavy-duty','victim','cathode-ray_tube','assailant','passage','bay_window','Noah','practical_joke','none','goulash','aggrandize','attract','silverware','strong-arm',
  'ironware','thousandth','anoint','shuffleboard','coquettish','teardrop','underground','paginate','scornful','district','blindfold','anaconda','disfranchise','backing','fed_up','antonym','industrial_park','posit','navigable',
  'space-age','soul','wobble','model','askance','bind','workplace','varmint','verity','inn','fertile','bless','sympathetic','piccalilli','Achilles_tendon','decorator','wickerwork','Mediterranean','tremendous','dismal','decorate','alumni',
  'beat','reconciliation','tap_dance','plating','context','critical','nuncio','rebellion','GMT','chicory','clash','bachelor','roundish','rustic','perfectionism','ski_lift','croquette','refundable','outlay','sepsis','fail-safe',
  'bifurcation','require','experiment','pianissimo','shy','indulgent','flash_card','wheeler-dealer','putative','humbug','multilateral','non_sequitur','twosome','sophistry','course','mendacious','cologne','SOS','ignominious','mow',
  'deck','refectory','bounds','underdone','godchild','meteorology','pendant','semantic','tarantula','wizardry','minnow','world_wide_web','binnacle','happy','stopover','military_police','CD','advancement','nobleman','continuous','better',
  'poet','figure','needy','marsupial','opening','whiskey','seed','interrelate','priority','yeasty','fiance','greenback','accession','treasury','east','cream_cheese','troika','jumpsuit','goalie','dray','pulsar','denominator','machiavellian',
  'generative','overproduction','baby-sat','presumptuous','candlestick','bilingual','salty','world_series','bowel','balsam','crawlspace','telephoto','shoot','curative','golly','bantam','reasonable','colloquialism','satire','crow',
  'higher-up','rotund','resource','turbot','pound_cake','term_paper','blind_date','disputant','dashiki','transcendence','bulletin_board','outcast','glockenspiel','dandruff','curious','pandemic','entourage','rails','spinal_cord','pauperism',
  'cut-and-dried','deer','laughable','unsuccessful','crossbar','putty','arbitrator','asymmetrical','congest','scholastic','pc','sleepyhead','x-rated','unseemly','addict','cloven','flavorful','prearrange','shout','arboreal','paralyze',
  'intermediate','foolery','salivation','madman','sensuous','optics','fallibility','witness','features','overage','crumble','announcer','cubic','disputatious','rarefy','vulture','indigence','conjugate','imagination','gaunt',
  'bus','civilization', 'elector','angora','sour','stage_fright','doable','raillery','aerospace','bobby_pin','what','perk','pole','decease','iterate','cuban','strung','ruffian','one-to-one','disseminate','unprincipled',
  'dispute','content','kooky','speckle','unadorned','brown_sugar','keyhole','insole','crackle','mythical','think','find','frontispiece','awoke','hosanna','dwindle','constabulary','decrepitude','fungi','shoptalk','liner',
  'swarm','floozy','monopolist','burglar_alarm','dissidence','alleviation','unfathomable','unasked','oceangoing','foregoing','forgivable','north_star','enslavement','laughingstock','forgave','true','tulip','seesaw','dote',
  'ministry','unnecessary','taken','parting','inestimable','undemocratic','clipper','grog','civilized','mystique','westward','serial','passerby','inferiority','ricochet','fry','disposable','mooring','decontamination','anchorman',
  'transatlantic','temperance','proper_noun','halyard','villain','distinct','flat-out','weirdo','coral','employer','vinaigrette','ventilator','collection','dismay','natty','starry-eyed','gunboat','precursor','prognosis','indiscretion',
  'part','alarm_clock','ruby','madden','ourselves','goldfinch','wholehearted','snoot','pantry','lacy','inboard','fanciful','sorbet','disinfectant','got','unlisted','baseball','ungovernable','past','mercy','playoff','besides',
  'juror','lessen','fortification','toothsome','comforter','deploy','discriminatory','pronouncement','bookmark','equator','house','irreversible','apostasy','entrant','frontiersman','infatuate','slacks','clarinetist',
  'impolite','matron','funny','secretarial','optimism','quarter_horse','melee','cellist','lease','stand-up','eucharist','hospitality','oxbow','lasso','obtainable','image','venom','videocassette','download','green','gigantic',
  'unoccupied','drawback','shot_put','pro','cruiser','grotto','cut-rate','supplement','new_year\'s_day','louse','brand','wayward','symphony','oppress','rivalry','into','marquess','quiche','genealogical','disadvantaged',
  'baby-sit','impregnate','cotton_candy','partisanship','so-and-so','moneymaker','mucus','abattoir','matte','cafe','graphology', 'never','ranch_house','nevermore','quartz','voltmeter','bereft','irishwoman','descriptive','jelly',
  'diverse','duster','swan_song','identify','drag_race','dew_point','rough-and-tumble','effusion','pilfer','hyacinth','miscount','few','pregnancy','ointment','open','surge','backpack','interjection','biotechnology','decrease','socialist',
  'foment','luggage','venue','latent','overalls','bucket_seat','unfasten','cyclone','unguent','skin','rigid','actuate','attrition','modernistic','subscript','capacity','workaholic','rubicund','versification','assign','revocation',
  'compensate','nuts','voluntary','decry','absorption','inconvenience','impede','scamp','capacious','furthermost','trickster','has-been','boot_camp','hemoglobin','northerner','congregate','iota','henchman','lament','calabash',
  'avenge','newsworthy','artillery','antibody','dread','bridle_path','craft','tangy','short-handed','ferret','thirteenth','reception','environmental','swank','fruitless','self-starter','fixings','banshee','shopworn','quad','doe','woodworking',
  'he','quiet','superstructure','composite','diacritical_mark','gainsay','gauze','perturb','awhile','wipe','far-fetched','massacre','hunger','public_school','heartburn','integral','observe','see','algebraic','nutritious','clamorous',
  'uninhibited','cuddly','effort','obsess','archery','system','manage','jackrabbit','friend','alma_mater','disown','driveway','resourceful','roman_numeral','underwent','evaporate','fulcrum','paw','catch','relocate','virtually',
  'campsite','nice','planter','anthology','intelligibility','instantaneous','deplete','oriental','reward','pesticide','denominational','conceptual','lonely','sidesaddle','countryside','article','mangrove','deepen','backpedal','sly',
  'sensible','waffle','last','ruckus','conscription','popular','concierge','miscreant','reunion','dextrose','wormwood','utopia','writ','continue','veterinary','spaced-out','jodhpurs','handwork','platonic','karate','overpaid','gimmickry',
  'scum','jigger','penury','outrank','peccadillo','appear','guillotine','scrambler','timely','interpretative','subliminal','fifth','messiah','warthog','contrivance','suitability','regulate','redneck','toad','preside','risible','eradicate',
  'siege','spatial','blessing','unveil','insurrectionist','always','mayfly','clumsy','steamship','smash-up','macrobiotic','slanderous','vicar','telemetry','third_person','painstaking','hunger_strike','world','outgrow','checkered','clinch',
  'persuasion','send-off','drum','lechery','crotchety','easily','lionize','hurt','tin_plate','curler','uproarious','druggist','ballot','cold_feet','falter','tendentious','tavern','flow','recite','lasagna','accusatory','node','extravaganza',
  'bismuth','imperishable','singe','emergence','creation','turkey','congenital','nut','coaxial_cable','layoff','repentance','reptilian','lifeboat','tights','vamp','ant','abdicate','chiffon','diffuse','verdure','lager','rocking_horse','reenactment',
  'motherly','zigzag','run-of-the-mill','physics','correspondent','place_mat','colt','screwy','miniature','disapprovingly','apoplexy','canyon','fraudulence','morphine','homophobia','overstock','condor','run-through','roost','inca','knitting',
  'soundproof','confectionery','misjudgment','anomaly','heir_apparent','tangled','saline','water_ski','extension_cord','grange','procrastinate','stopcock','intercollegiate','loudmouth','solaria','waspish','pullman','dramatize','thermometer',
  'presidential','discontented','knitwear','lice','zirconium','inbound','plenary','subservience','duty','sci-fi','dwelt','squawk','savings_bank','migratory','process','appropriate','lilac','germanic','goody-goody','tablet','squish','reverence',
  'convergent','deploying','funky','overzealous','grocery','junior_college','agglutination','anathema','satiety','coordination','peptic','appraisal','piecemeal','regain','tired','stock_car','delve','gelatinous','achoo','mistrustful','apiece',
  'village','anvil','fire_station','kleptomania','loony_bin','remarkable','jargon','plant','loyalty','green_bean','gold_medal','heap','realism','paring','glossy','miscalculate','pontificate','cryptic','rhinestone','ganglia','school_year','restate',
  'undersigned','lisp','pea','respectively','mangle','flatfish','black_belt','meaning','monsoon','wholly','glorify','infringement','adman','ratification','database','tress','technical','trash_can','mentor','ottoman','anchorage','confess','stalemate',
  'consecrate','viewer','thong','enroll','acknowledge','implacability','doubly','black_sheep','assumption', 'teleconference','father_figure','plantation','territory','pestle','ramification','commiseration','briquette','dividend','mighty','desolation',
  'solid-state','incestuous','brash','essential','moisten','prescriptions','god-fearing','awesome','roundworm','glider','mentality','seaweed','punk','senseless','amorphous','upshot','good-hearted','wrathful','presume','enlarge','agile',
  'murky','tannin','rheumy','misplace','internationalism','marry','sheer','freeze-dried','bolster','casanova','healthful','sisal','anarchistic','appellate','snivel','deplorable','acrobatic','chasten','typographical','o\'clock','preparatory_school',
  'scrubby','snub-nosed','hieroglyphic','pluck','chafe','binary','especial','brooder','fur','contextual','ago','hind','deathless','quiver', 'brook','immaturity','pressurize','trapshooting','degrading','blur','giant','vest-pocket',
  'right_field','antiaircraft','public-spirited','dollar','frightened','heavyweight','changeling','ritual','downsize','broadcloth','pushover','fixture','gift','alpha','puma','cartridge','blind','under','unsaddle','do-it-yourself',
  'excel','saltwater','yellow_jacket','contrast','cruddy','observance','mercy_killing','disarray','figurehead','fluster','dog_tag','lacrosse','pop_quiz','electric_guitar','cataract','nominative','chairlift','amateurish','apposite','useless']

def write_tag(file, id)
  file.write("INSERT INTO tags (id, name, created_at, updated_at) VALUES(#{id}, \"#{TAG_WORDS[id - 100]}\", NOW(), NOW());\n")
end

def write_hacker(file, id)
  password = Faker::Address.street_name.gsub(' ', '_')
  file.write("/* Hacker password is: #{password}. */\n")
  file.write("INSERT INTO subscriptions (id, premium_account, created_at, updated_at) VALUES(#{id}, 0, NOW(), NOW());\n")
  file.write("INSERT INTO hackers (id, subscription_id, email, name, auth_token, password_digest, created_at, updated_at) VALUES(#{id}, #{id}, \"#{Faker::Internet.email}\", \"#{Faker::Name.first_name}\", \"#{BCrypt::Password.create(Faker::Internet.domain_word())}\", \"#{BCrypt::Password.create(password)}\", NOW(), NOW());\n")
end

def write_entry(file, hacker_id, entry_id, day, tag_range)
  file.write("INSERT INTO entries (id, hacker_id, content, created_at, updated_at) VALUES(#{entry_id}, #{hacker_id}, \"#{Faker::Lorem.paragraph}\", SUBDATE(NOW(), #{day}), SUBDATE(NOW(), #{day}));\n")
  
  # Random number of associated tags.
  tag_count = (rand 5) + 1
  
  tags = []
  (0...20).each do
    tags << (rand 100) + tag_range
  end
  tags.uniq!

  (0...tag_count).each do |x|
    file.write("INSERT INTO entries_tags (entry_id, tag_id) VALUES(#{entry_id}, #{tags[x]});\n")
  end
end

File.open(FILL_FILE, 'w') do |file|

  # Seed one thousand tags.
  (100...1100).each do |id|
    write_tag(file, id)
  end

  # Start hacker records.
  file.write("/* Hackers */\n\n")

  entry_id_last = 1
  (100...200).each do |hacker_id|
    write_hacker(file, hacker_id)
    
    # Random number of entries
    entry_count = rand 100
    if hacker_id == 100
      entry_count = 300
    end
    
    # Create a smaller range to select tags from.
    tag_range = ((rand 10) + 1) * 100 # 100 - 1100
    
    days_old = entry_count
    (entry_id_last..entry_id_last + entry_count).each do |entry_id|
      write_entry(file, hacker_id, entry_id, days_old, tag_range)
      days_old -= 1
    end
    
    entry_id_last += entry_count + 1
  end
  
end