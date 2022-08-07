//todo:
// Add custom ability to add user own quotes.
// Move quotes to another lua file.

// Classic Call Of Duty: Death Quotes
// credit for most of the basework of this addon to https://github.com/T0bycat/TLOU-Death-Screen-Effect
// This was the inspiration of TLOU death screen
local deathsystem = CreateClientConVar("cod_death_system", 1, true, false, "Enable the death system?", 0, 1)
local deathsound = CreateClientConVar( "cod_death_sound", 1, true, false, "If 1, use COD2/MW2/MW3 Sound. If 2, use COD3 Sounds. If 3, use COD W@W Sound. if 4, use COD BO1 Sound. If 5, use COD BO2 sound. If 6, use AW sound. If 7, use MW2019 sound.", 0, 7 )
local cod_quotes = CreateClientConVar( "cod_death_quotes", 1, true, false, "Which quote set to use. 0 - Disable quotes. 1 - Call Of Duty (Default). 2 - Call To Arms (COD2 Mod). 3 - Funny / Memes. 4 - Informational. 5 - Use All.", 0, 5 )
local deathcamera_effect = CreateClientConVar( "cod_death_camera", 1, true, false, "0 - No Camera change. 1 - Camera tilt. 2 - No camera tilt.", 0, 2 )
local screenfadeout = CreateClientConVar("cod_death_screenfade", 1, true, false, "Enable the screen fadeout on death? 0 - No screenfade, 1 - Screenfade on death.", 0, 1)
local blureffects = CreateClientConVar("cod_death_screenblur", 1, true, false, "Enable the screen blur on death? 0 - No screenblur, 1 - Screenblur on death.", 0, 1)

local function CoDQuoteSettings()
    spawnmenu.AddToolMenuOption( "Options", "CoD: Death Screen Quotes", "CoD: Death Screen Quotes", "Options", "", "", function( panel )
        panel:Help('Clientside options')
        panel:CheckBox('Enable Call Of Duty Deathscreen system?','cod_death_system')
        panel:CheckBox('Enable screen fadeout on death?','cod_death_screenfade')
        panel:CheckBox('Enable screen blur effects on death?','cod_death_screenblur')
        local cambox = panel:ComboBox("Death Camera", "cod_death_camera")
        cambox:SetSortItems(false)
        cambox:AddChoice("Disable first person camera", 0)
        cambox:AddChoice("Classic style tilting", 1)
        cambox:AddChoice("No camera tilt", 2)
        local quotebox = panel:ComboBox("Death Quotes", "cod_death_quotes")
        quotebox:SetSortItems(false)
        quotebox:AddChoice("Disable quotes", 0)
        quotebox:AddChoice("Call Of Duty (Default)", 1)
        quotebox:AddChoice("Call To Arms (COD2 Mod)", 2)
        quotebox:AddChoice("Funny / Memes", 3)
        quotebox:AddChoice("Informational", 4)
        quotebox:AddChoice("All", 5)
        local soundbox = panel:ComboBox("Death Sound", "cod_death_sound")
        soundbox:SetSortItems(false)
        soundbox:AddChoice("Random", 0)
        soundbox:AddChoice("Call Of Duty 2 / Modern Warfare 2", 1)
        soundbox:AddChoice("Call Of Duty 3 (Multiple Sounds)", 2)
        soundbox:AddChoice("Call Of Duty: World At War", 3)
        soundbox:AddChoice("Call Of Duty: Black Ops 1", 4)
        soundbox:AddChoice("Call Of Duty: Black Ops 2", 5)
        soundbox:AddChoice("Call Of Duty: Advanced Warfare", 6)
        soundbox:AddChoice("Call Of Duty: Modern Warfare 2019", 7)
    end)
end

hook.Add("PopulateToolMenu", "AddCODScreenSettings", CoDQuoteSettings)
hook.Add("PlayerDeathSound", "DeFlatline", function() return true end) -- Removes the damn annoying beep beep beeep beeeeee sound.

if ( CLIENT ) then
    surface.CreateFont( "COD_DEATH_QUOTEFONT", {
        font = "HudHintTextLarge",
        extended = false,
        size = ScrW() * 0.018,
        weight = 400,
        blursize = 0,
        scanlines = 0,
        antialias = false,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = true,
        outline = true,
    } )

    local tbl_callofduty_quotes = {  
        "'Never in the field of human conflict was so much owed by so many to so few.' - Winston Spencer-Churchill",
        "'Success is not final, failure is not fatal: it is the courage to continue that counts.' - Winston Spencer-Churchill",
        "'In war there is no prize for the runner-up.' - Omar N. Bradley, U.S. Army General",
        "'There never was a good war or a bad peace.' - Benjamin Franklin",
        "'It is fatal to enter any war without the will to win it.' - General Douglas MacArthur",
        "'In war, you win or lose, live or die-and the difference is just an eyelash.' - General Douglas MacArthur",
        "'Untutored courage is useless in the face of educated bullets.' - General George S. Patton",
        "'May God have mercy upon my enemies, because I won't.' - General George S. Patton",
        "'So long as there are men there will be wars.' - Albert Einstein",
        "'Therefore, whoever wishes for peace, let him prepare for war.' - Vegetius",
        "'The real war will never get in the books.' - Walt Whitman",
        "'There is no honorable way to kill, no gentle way to destroy. There is nothing good in war. Except its ending.' - Abraham Lincoln",
        "'The death of one man is a tragedy. The death of millions is a statistic.' - Joseph Jughashvili (Stalin)",
        "'Death solves all problems - no man, no problem.' - Joseph Jughashvili (Stalin)",
        "'In the Soviet army, it takes more courage to retreat than advance.' - Joseph Jughashvili (Stalin)",
        "'The object of war is not to die for your country but to make the other bastard die for his.' - General George S. Patton",
        "'It is foolish and wrong to mourn the men who died.\n Rather we should thank God that such men lived.'\n\n                              - General George S. Patton",
        "'War is fear cloaked in courage.' - General William C. Westmoreland",
        "'I have never advocated war except as a means of peace.' - Ulysses S. Grant",
        "'Older men declare war. But it is the youth that must fight and die.' - Herbert Hoover",
        "'Only the dead have seen the end of the war.' - Plato",
        "'War does not determine who is right - only who is left.' - Bertrand Russell",
        "'Death is nothing, but to live defeated and inglorious is to die daily.' - Napoleon Bonaparte",
        "'Patriots always talk of dying for their country and never of killing for their country.' - Bertrand Russell",
        "'All that is necessary for evil to succeed is for good men to do nothing.'\n\n                              - Edmund Burke, British statesman and philosopher",
        "'It is well that war is so terrible, or we should get too fond of it.' - General Robert E. Lee",
        "'A soldier will fight long and hard for a bit of colored ribbon.' - Napoleon Bonaparte",
        "'He who fears being conquered is sure of defeat.' - Napoleon Bonaparte",
        "'You must not fight too often with one enemy, or you will teach him all your art of war.' - Napoleon Bonaparte",
        "'The real and lasting victories are those of peace, and not of war.' - Ralph Waldo Emerson",
        "'If we don't end war, war will end us.' - H. G. Wells",
        "'From my rotting body, flowers shall grow and I am in them and that is eternity.' - Edvard Munch",
        "'He who did well in war just earns the right to begin doing well in peace.' - Robert Browning",
        "'There is nothing so likely to produce peace as to be well prepared to meet the enemy.' - George Washington",
        "'Never yield to force;\n never yield to the apparently overwhelming might of the enemy.'\n\n - Winston Spencer-Churchill"  ,
        "'War is delightful to those who have not experienced it.' - Desiderius Erasmus Roterodamus",
        "'War is as much a punishment to the punisher as it is to the sufferer.' - Thomas Jefferson",
        "'War would end if the dead could return.' - Stanley Baldwin",
        "'You can't say civilization don't advance - for in every war, they kill you in a new way.' - Will Rogers",
        "'In peace the sons bury their fathers, but in war the fathers bury their sons.' - Croesus",
        "'We make war that we may live in peace.' - Aristotle",
        "'The quickest way of ending a war is to lose it.' - George Orwell",
        "'The only winner in the War of 1812 was Tchaikovsky.' - Solomon Short",
        "'If you are going through hell... keep going.' - Winston Spencer-Churchill",
        "'In peace, as a wise man, he should make suitable preparation for war.' - Horace",
        "'War is cruelty. There is no use trying to reform it. The crueler it is, the sooner it will be over.'\n\n                              - General William Tecumseh Sherman",
        "'In war, there are no unwounded soldiers.' - Jose Narosky",
        "'The essence of war is violence. Moderation in war is imbecility.' - John Arbuthnot Fisher",
        "'Soldiers usually win the battles and generals get the credit for them.' - Napoleon Bonaparte",
        "'I don't know whether war is an interlude during peace, or peace is an interlude during war.' - Georges Clemenceau",
        "'No one can guarantee success in war, but only deserve it.' - Winston Spencer-Churchill",
        "'The military don't start wars. Politicians start wars.' - General William C. Westmoreland",
        -- call of duty 3
        "'I guess every generation is doomed to fight its war... suffer\nthe loss of the same old illusions, and learn the same old\nlessons on its own.'\n - Philip Caputo"
    }
    -- Professor DSD and his team for their COD2 mod
    local tbl_callofduty2_c2a_quotes = {
        "'I alone cannot change the world, but I can cast a stone across the waters to create many ripples.' - Mother Teresa",
        "'You never know how strong you are until being strong is your only choice.' - Bob Marley",
        "'How glorious fall the valiant, sword in hand, in fornt of battle for their native land!' - King Agesilaus, Sparta",
        "'Victory belongs to the most persevering.' - Napoleon Bonaparte",
        "'The greatest glory in living lies not in never falling, but in rising every time we fall.' - Neslon Mandela",
        "'Better to live in a rugged land and rule than to cultivate rich plains and be a slave.' - Cyrus the Great",
        "'War is over... If you want it.' - John Lennon",
        "'The only victories which leave no regret are those which are gained over ignorance.' - Napoleon Bonaparte",
        "'In every defeat is a lesson showing you how to win the victory next time.' - Robert Collier",
        "'You can learn little from victory. You can learn everything from defeat.' - Christy Mathewson",
        "'Of the four wars in my lifetime, none came about because the U.S. was too strong.' - Ronald Reagan",
        "'Not all dreamers are winners, but all winners are dreamers. Your dream is the key to your future.' - Mark Gorman",
        "'Success is going from failure to failure without lost of enthusiasm.' - Winston Spencer-Churchill",
        "'The only thing we have to fear is fear itself.' - Franklin D. Roosevelt",
        "'War would end if the dead could return.' - Stanley Baldwin",
        "'Against all odds, if you still persist and create your art, it will be a victory! It will be your victory. Finally, you would win.' - Avijeet Das",
        "'What the war did to dreamers.' - Anthony Doerr",
        "'I think whether you're having setbacks or not, the role of a leader is to always display a winning attitude.' - Colin Powell",
        "'An unjust peace is better than a just war.' - Marcus Tullius Cicero",
        "'We are going to have peace even if we have to fight for it.' - Dwight D. Eisenhower",
        "'For country, children, hearth, and home.' - Sallust",
        "'I would not say that the future is necessarily less predictable than the past.\n I think the past was not predictable when it started.'\n\n - Donald Rumsfeld",
        "'Principle is OK up to a certain point, but principle doesn't do any good if you lose.' - Dick Cheney",
        "'Victory is not won in miles but in inches. Win a little now, hold your ground, and later win a little more.' - Louis L'Amour",
        "'Accept the challenges so that you can feel the exhilaration of victory.' - General George S. Patton",
        "'Never fear your enemy, but always respect them.' - John Basilone, Medal of Honor Winner, WWII",
        "'Always carry champagne! In victory You deserve it and in defeat You need it!' - Napoleon Bonaparte",
        "'Victory is always bittersweet.' - Nadia Scrieva",
        "'If you want victory in your life you must learn to be alone with your own thoughts and cause them to be correct thoughts!' - Sandra Hersey",
        "'Future is ours, but victory is mine!' - Aditia Rinaldi",
        "'Hope is a waking dream' - Aristotle",
        "'Those who really fight has no time to cry.' - Muhammad Mamduh",
        "'I am a war president.' - George W. Bush",
        "'Revenge is profitable.' - Edward Gibbon",
        "'Ask not what your country can do for you, but what you can do for your country.' - John F. Kennedy",
        "'Be where your enemy is not.' - Sun-Tzu",
        "'Traditional nationalism cannot survive the fissioning of the atom. One world or none.' - Stuart Chase",
        "'Victory is always possible for the person who refuses to stop fighting.' - Napoleon Hill",
        "'The first step on the way to victory is to recognize the enemy.' - Corrie ten Boom",
        "'Set your face towards danger. Set your heart on victory.' - Gail Carson Levine",
        "'I count him braver who overcomes his desires than him who conquers his enemies;\n for the hardest victory is over self.'\n\n                              - Aristotle",
        "'No one can make you feel inferior without your consent.' - Eleanor Roosevelt",
        "'The means by which we achieve victory are as important as the victory itself.' - Brandon Sanderson",
        "'Cowards die many times before their deaths;\n The valiant never taste of death but once.'\n\n                              - William Shakespeare",
        "'It is the cause, not the death, that makes the martyr.' - Napoleon Bonaparte",
        "'A successful man is one who can lay a firm foundation with the bricks others have thrown at him.' - David Brinkley",
        "'No one really knows why they are alive until they know what they'd die for.' - Martin Luther King Jr.",
        "'Better to live in a rugged land and rule than to cultivate rich plains and be a slave.' - Cyrus the Great",
        "'Victory is reserved for those who are willing to pay its price.' - Sun-Tzu",
        "'Out of suffering have emerged the storngest souls.' - Khalil Gibran, 'The Voice of the Poet'",
        "'I abhor unjust war, I abhor injustice and bullying by the strong at the expense of the weak.' - Theodore Roosevelt",
        "'Let no man surrender so long as he is unwounded and can fight.' - Bernard Law Montgomery",
        "'It is not enough to win a war;\n it is more important to organize the peace.'\n\n - Aristotle",
        "'Injustice anywhere is a threat to justice everywhere.' - Martin Luther King Jr.",
        "'When the rich wage war, it's the poor who die.'- Jean-Paul Sartre",
        "'I count him braver who overcomes his desires than him who conquers his enemies;\n for the hardest victory is over self.'\n\n                              - Aristotle",
        "'I guess the only time most people think about injustice is when it happens to them.' - Charles Bukowski",
        "'Do not make mistake of thinking that you have to agree with people and their beliefs to defend them from injustice.' - Bryant McGill",
        "'One man's terrorist is another man's freedom fighter.' - American Academy of Political and Social Science",
        "'If the highest aim of a captain were to preserve his ship, he would keep it in port forever.' - Thomas Aquinas",
        "'War is only cowardly escape from the problems of peace.' - Thomas Mann",
        "'Whatever possession we gain our sword cannot be sure or lasting.' - Alexander the Great",
        "'I am not only a pacifist but a militant pacifist. I am willing to fight for peace.' - Albert Einstein",
        "'It is during our darkest moments that we must focus to see the light.' - Aristotle",
        "'Humanity is an ocean. If a few drops of the ocean are dirty, the ocean does not become dirty.' - Mahatma Gandhi",
        "'The art of war is simple enough. Find out where your enemy is. Get at him as soon as you can.' - Ulysses S. Grant",
        "'In time of war, the first casualty is truth.' - Boake Carter, radio commentator",
        "'Even brute beasts and wandering birds do not fall for the same traps or nets twice.' - Saint Jerome",
        "'Where tillage begins, other arts follow. The farmers therefore are the founders of human civilization.' - Daniel Webster",
        "'If we lose the war in the air we lose the war and we lose it quickly.' - Bernard Law Montgomery",
        "'Nearly all men can stand adversity, but if you want to test a man's character, give him power.' - Abraham Lincoln",
        "'Secret operations are essential in war;\n upon them the army relies to make its every move.'\n\n - Sun-Tzu",
        "'A bad peace is worse than war.' - Tacitus",
        "'When the war of the giants is over the wars of the pygmies will begin.' - Winston Spencer-Churchill",
        "'All wars are follies, very expensive and very mischievous ones.' - Benjamin Franklin",
        "'There is no glory in battle worth the blood it costs.' - Dwight D. Eisenhower",
        "'The commander in the field is always right and the rear echelon is wrong, unless proved otherwise.' - Colin Powell",
        "'In the end, it was luck. We were *this* close to nuclear war, and luck prevented it.' - Robert McNamara",
        "'It has too often been too easy for rulers and governments to incite man to war.' - Lester B. Pearson",
        "'Unless a nation's life faces peril, war is murder.' - Mustafa Kemal Ataturk",
        "'Freedom is not free, but the U.S. Marine Corps will pay most of your share.' - Ned Dolan",
        "'It's better to burn out than to fade away.' - Neil Young",
        "'The dead can survive as part of the lives of those that still live.' - Kenzaburo Oe",
        "'War is devastating, and it leaves it's scars for generations.' - James Blunt",
        "'Sweat saves blood.' - Field Marshal Erwin Rommel",
        "'Conquered, we conquer.' - Plautus",
        "'My first wish is to see this plague of mankind, war, banished from the earth.' - George Washington",
        "'To hold a pen is to be at war.' - Francois Marie Arouet (Voltaire)",
        "'Ten soldiers wisely led will beat a hundred without a head.' - Euripides",
        "'There is no avoiding war; it can only be postponed to the advantage of others.' - Niccolo Machiavelli",
        "'War is peace. Freedom is slavery. Ignorance is strength.' - George Orwell",
        "'Our business in the field of fight, Is not to question, but to prove our might.' - Alexander Pope",
        "'Not at all similar are the race of the immortal gods and the race of men who walk upon the earth.' - Homer, Illiad",
        "'You can't direct the wind, but you can adjust your sails.' - Anonymous",
        "'True glory consists in doing what deserves to be written, in writing what deserves to be read.' - Pliny the Elder",
        "'Some books are to be tasted, others to be swallowed,\n and some to be chewed and digested.'\n\n                              - Francis Bacon",
        "'The whole is more than the sum of its parts.' - Aristotle",
        "'It is from their foes, not their friends, that cities learn the lesson of building high walls.' - Aristophanes",
        "'No soldier ever really survives a war.' - Audie Murphy",
        "'If men do not now succeed in abolishing war, civilization and mankind are doomed.' - Ludwig von Mises",
        "'All delays are dangerous in war.' - John Dryden",
        "'Hope is a waking dream.' - Aristotle",
        "'We cannot think of being acceptable to others until we have first proven acceptable to ourselves.' - Malcolm X",
        "'Terrorism is the war of the poor, and the war is the terrorism of the rich.' - Sir Peter Alexander Ustinov",
        "'It is the youth who must inherit the tribulation, the sorrow... that are the aftermath of war.' - Herbert Hoover",
        "'The conqueror is always a lover of peace; he would prefer to take over our country unopposed.' - Carl von Clausewitz",
        "'The world will not destroyed by those who do evil, but by those who watch them without doing anything.' - Albert Einstein",
        "'Soon we shall either kill the barbarians or else we are bound to be killed ourselves.' - King Leonidas, Sparta",
        "'Terrorism must be outlawed by all civilized nations, not explained or rationalized, but fought and eradicated.' - Elie Wiesel",
        "'Nations, like individuals, are punished for their transgressions.' - Ulysses S. Grant",
        "'No countries are less prepared to deal with terrorism than Western democracies.' - Winston Spencer-Churchill",
        "'I think the human race needs to think about killing. How much evil must we do to do good?' - Robert McNamara",
        "'Freedom itself was attacked this morning by a faceless coward, and freedom will be defended.' - George W. Bush",
        "'The supreme excellence is to subdue the armies of your enemies without even having to fight them...'\n\n                              - Sun-Tzu",
        "'For what can war, but endless war, still breed?' - John Milton",
        "'Your enemy is not the refugee. Your enemy is the one who made him a refugee.' - Tariq Ramadan",
        "'War is the business of barbarians.' - Napoleon Bonaparte",
        "'If I charge, follow me. If I retreat, kill me. If I die, revenge me.' - USMC",
        "'Bravery is the capacity to perform properly even when scared half to death.'\n\n - Omar N. Bradley, U.S. Army General",
        "'Truth is stranger than fiction, but it is because Fiction is obliged to stick to possibilities;\n Truth isn't.'\n\n - Mark Twain",
        "'War is not an adventure. It is a disease. It is like typhus.' - Antoine de Saint-Exupery",
        "'The way to win an atomic war is to make certain it never starts.' - Omar N. Bradley, U.S. Army General",
        "'True patriotism hates injustice in its own land more than anywhere else.' - Clarence Darrow",
        "'When will mankind be convinced and agree to settle their difficulties by arbitration?' - Benjamin Franklin",
        "'Never fear your enemy, but always respect them' - John Basilone, Medal of Honor Receiver, WWII",
        "'A just war is in the long run far better for a man's soul than the most prosperous peace.' - Theodore Roosevelt",
        "'In a man to man fight the winner is he who has one more round in his magazine.' - Field Marshal Erwin Rommel",
        "'We will prevent war, whatever it takes.' - Moon Jae-in",
        "'Do nothing that is of no use' - Miyamoto Musashi",
        "'You must understand that there is more than one path to the top of the mountain.' - Miyamoto Musashi",
        "'I hope peace is a part of everyday life.' - Moon Jae-in",
        "'War is the science of destruction.' - John S.C. Abbot",
        "'A man who won't die for something is not fit to live.' - Martin Luther King Jr.",
        "'We'll guarantee you a medal, a body bag, or both.' - Delta",
        "'Only those who will risk going too far can possibly find how far one can go.' - T.S. Eliot",
        "'God fights on the side with the best artillery.' - Napoleon Bonaparte",
        "'Honor the dead, fight like hell for the living.' - Anonymous",
        "'History does not long entrust the care of freedom to the weak or timid.' - Dwight D. Eisenhower",
        "'One cannot simultaneously prevent and prepare for war.' - Albert Einstein",
        "'War is always a matter of doing evil in the hope that good may come of it.' - Sir Basil H. Liddel-Hart",
        "'I want to wage war against illiteracy, poverty, unemployment, unfair competition, communitarianism, delinquency.'\n\n - Nicolas Sarkozy",
        "'World War II, the atomic bomb, the Cold War, made it hard for Americans to continue their optimism.' - Stephen Ambrose",
        "'War hath no fury like a non-combatant.' - Charles Edward Montague",
        "'I am become death, the destroyer of worlds.' - Robert Oppenheimer",
        "'The object of war is victory; that of victory is conquest; and that of conquest preservation.' - Montesquieu",
        "'There is nothing glamorous or romantic about war. It's mostly about random pointless death and misery.' - Jon Krakauer",
        "'There is so much that must be done in a civilized barbarism like war.' - Amelia Earhart",
        "'We cannot banish dangers, but we can banish fears. We must not demean life by standing in awe of death.' - David Sarnoff",
        "'The State thrives on war - unless, of course, it is defeated and crushed - expands on it, glories in it.' - Murray Rothbard",
        "'All wars are fought for money.' - Socrates",
        "'A thing is not necessarily true because a man dies for it.' - Oscar Wilde",
        "'Unbeing dead isn't being alive.' - E. E. Cummings",
        "'There are no absolute rules of conduct, either in peace or war. Everything depends on circumstances.' - Leon Trotsky",
        "'The accounting of the sacrifice is, more than anything else,\n the attitude toward war memorials in our time.'\n\n - Friedrich St. Florian",
        "'Death is not the opposite of life, but a part of it.' - Haruki Murakami",
        "'Fear not death for the sooner we die, the longer we shall be immortal.' - Benjamin Franklin",
        "'The worst evils which mankind has ever had to endure were inflicted by bad governments.' - Ludwig von Mises",
        "'It is not reasonable that those who gamble with men's lives should not stake their own.' - H. G. Wells",
        "'The best fortress which a prince can possess is the affection of his people.' - Niccolo Machiavelli",
        "'War makes rattling good history; but Peace is poor reading.' - Thomas Hardy",
        "'War demands sacrifice of the people. It gives only suffering in return.' - Frederic Clemson Howe",
        "'The power of making war often prevents it.' - Thomas Jefferson",
        "'I regret not death. I am going to meet my friends in another world.' - Ludovico Ariosto",
        "'Peace hath higher tests of manhood than battle ever knew.' - John Greenleaf Whittier",
        "'One more such victory and we're undone.' - Pyrrhus of Epirus",
        "'O peace! How many wars were waged in thy name.' - Alexander Pope",
        "'I must study politics and war that my sons may have liberty to study mathematics and philosophy...' - John Adams",
        "'War: a wretched debasement of all the pretenses of civilization.' - Omar N. Bradley, U.S. Army General",
        "'In war there is no substitute for victory.' - General Douglas MacArthur",
        "'Better to fight for something than live for nothing.' - General George S. Patton",
        "'Courage is fear holding on a minute longer.' - General George S. Patton",
        "'A merely fallen enemy may rise again, but the reconciled one is truely vanquished.' - Johan Christoph Stiller",
        "'All the war-propaganda, all the screaming and lies and hatred, comes invariably from people who are not fighting.'\n\n                              - George Orwell",
        "'We are advocates of the abolition of war, we do not want war;\n but war can only be abolished through war.'\n\n - Mao Zedong",
        "'I do not know with what weapons World War III will be fought,\n but I do know that World War IV will be fought with rocks.'\n\n - Albert Einstein",
        "'If civilization has an opposite, it is war. Of these two things, you have either one, or the other. Not both.'\n\n - Ursula K. Le Guin",
        "'War is not a life: it is a situation. One which may neither be ignored nor accepted.' - T.S. Eliot",
        "'Wars do not end wars any more than an extraordinarily large conflagration does away with the fire hazard.' - Henry Ford",
        "'Beware the toils of war... the mesh of the huge dragnet sweeping up the world.' - Homer, Illiad",
        "'War remains the decisive human failure.' - John Kenneth Galbraith",
        "'The sinews of war are infinite money.' - Marcus Tullius Cicero",
        "'A war is a horrible thing, but it's also a unifier of countries.' - Clint Eastwood",
        "'The real trouble with war (modern war) is that it gives no one a chance to kill the right people.' - Ezra Pound",
        "'War is failure of diplomacy.' - John Dingell",
        "'War is the remedy that our enemies have chosen, and I say let us give them all they want.'\n\n - General William Tecumseh Sherman",
        "'Politics is too serious a matter to be left to the politicians.' - Charles de Gaulle",
        "'Nothing great will ever be achieved without great men, and men are great only if they are determined to be so.' - Charles de Gaulle",
        "'Never relinquish the initiative.' - Charles de Gaulle",
        "'War is war. The only good human being is a dead one.' - George Orwell",
        "'War is not only a matter of equipment, artillery, group troops or air force;\n it is largely a matter of spirit, or morale.'\n\n - Chiang Kai-shek",
        "'There's nothing good that comes out of war.\n It's simply hell on earth, and people survive, and people don't.'\n\n                              - Michael Cimino",
        "'War are poor chisels for carving out peaceful tomorrows.' - Martin Luther King Jr.",
        "'A lasting order cannot be established by bayonets.' - Ludwig von Mises",
        "'All nations want peace, but they want a peace that suits them.' - Admiral Sir John Fisher",
        "'Wars teach us not to love our enemies, but to hate our allies.' - W. L. George",
        "'War is mainly a catalogue of blunders.' - Winston Spencer-Churchill",
        "'Force is all-conquering, but its victories are short-lived.' - Abraham Lincoln",
        "'I hope our wisdom will grow with our power, and teach us,\n that the less we use our power the greater it will be.'\n\n                              - Thomas Jefferson",
        "'Look back over the past, with its changing empires that rose and fell,\n and you can foresee the future too.'\n\n - Marcus Aurelius",
        "'It takes twenty years or more of peace to make a man;\n it only takes twenty seconds of war to destroy them.'\n\n - King Baudouin I of Belgium"
    }
    local tbl_funny_quotes = {
        "'WHAT!!!!?????' - DarkViperAU",
        "'This game sucks! What is this game? I've been playing this game for over 8,000 hours!'\n\n                              - DarkViperAU",
        "'That there is just a sad display boy.' - TF2 Engineer",
        "'You, are, a, bloody, disgrace!' - TF2 Sniper",
        "'Now I gotta make a necklace outta your teeth, bushman's rules.' - TF2 Sniper",
        "'How many times have you died? I'm actually getting impressed.' - TF2 Sniper",
        "'At least you died for honor... and my amusement!' - TF2 Spy",
        "'Perhaps they can bury you in that van you call home.' - TF2 Spy",
        "'Well, this was a disappointment!' - TF2 Spy",
        "'Less talk, more fight!' - TF2 Soldier",
        "'Never send a boy to fight a man's war.' - TF2 Soldier",
        "'You're a disgrace to the uniform.' - TF2 Soldier",
        "'This American boot just kicked your ass back to Russia' - TF2 Soldier",
        "'Your country did not prepare you for the level of violence you will meet on my battlefield!'\n\n                              - TF2 Soldier",
        "Mission failed! We'll get them next time.",
        "'Mr. Salieri sends his regards' - Vito Scaletta",
        "'For the last ten years, all I done was kill. \nI killed for my country, I killed for my family, I killed anybody that got in my way' \n- Vito Scaletta"
    }
    local tbl_info_quotes = {
        "Use WASD to move out of danger, then use M1 to attack.",
        "You've been killed. Watch for your healthbar when it gets low.",
        "Sometimes it's wise to flee from danger, rather than fighting it.",
        "Your Heads-Up Display will always show your healthbar, collect medkits to heal.",
        "Use cover to protect yourself against enemy fire.",
        "You can throw back grenades by pressing the Use key, then quickly lob it back.",
        "The Gravity Gun can lob various objects towards enemies.",
        "Remember to pick up Armor, you will survive longer with Armor.",
        "When you're almost dry on your primary weapon, always switch to another weapon. It's faster than reloading.",
        "Use your surrounding environment to your advantage.",
        "Staying in one spot is a recipe for diaster. Keep moving to avoid getting hurt!",
        "Use props to your advantage by blocking incoming enemy fire.",
        "Use grenades to flush enemies out of their cover, they will run out of their cover, leaving them openly exposed.",
        "Throw grenades back at enemies before the grenade detonates.",
        "Aiming at the head will almost certain result in a insta-kill.",
        "The Gravity Gun can effectively launch enemy-thrown grenades farther than normally throwing them."
    }
    local tbl_cod_all_quotes = {}
    table.Add(tbl_cod_all_quotes, tbl_callofduty_quotes)
    table.Add(tbl_cod_all_quotes, tbl_callofduty2_c2a_quotes)
    table.Add(tbl_cod_all_quotes, tbl_funny_quotes)
    table.Add(tbl_cod_all_quotes, tbl_info_quotes)
    -- print(#tbl_cod_all_quotes, #tbl_callofduty_quotes, #tbl_callofduty2_c2a_quotes, #tbl_funny_quotes, #tbl_info_quotes)
    -- PrintTable(tbl_cod_all_quotes)
    local tbl_noquotes = {
        
        ""
    }

    gameevent.Listen( "entity_killed" )
    hook.Add("entity_killed", "deathsystem", function(data)
        if deathsystem:GetBool() then -- If the number is above 0, we active the death system
            if data.entindex_killed == LocalPlayer():EntIndex() then
                local ply = LocalPlayer()
                local quote

                -- Prevents the message "nil" from appearing
                if !IsValid(Entity(data.entindex_inflictor)) or not Entity(data.entindex_inflictor):GetClass() then
                    quote = tbl_cod_all_quotes[math.random(#tbl_cod_all_quotes)]
                else -- If we detect what killed us, then we display the quotes
                    if IsValid(Entity(data.entindex_inflictor)) then
                        if cod_quotes:GetInt() == 0 then
                            quote = tbl_noquotes[math.random(#tbl_noquotes)]
                        elseif cod_quotes:GetInt() == 1 then
                            quote = tbl_callofduty_quotes[math.random(#tbl_callofduty_quotes)]
                        elseif cod_quotes:GetInt() == 2 then
                            quote = tbl_callofduty2_c2a_quotes[math.random(#tbl_callofduty2_c2a_quotes)]
                        elseif cod_quotes:GetInt() == 3 then
                            quote = tbl_funny_quotes[math.random(#tbl_funny_quotes)]
                        elseif cod_quotes:GetInt() == 4 then
                            quote = tbl_info_quotes[math.random(#tbl_info_quotes)]
                        elseif cod_quotes:GetInt() == 5 then
                            quote = tbl_cod_all_quotes[math.random(#tbl_cod_all_quotes)]
                        end
                    end
                end
                --print(quote)

                local sndint = deathsound:GetInt()
                local sndtbl = {
                    "deathsounds/mw2_death.ogg",
                    "deathsounds/cod3_death" .. math.random(5) .. ".ogg",
                    "deathsounds/waw_death" .. math.random(2) .. ".ogg",
                    "deathsounds/bo1_death.ogg",
                    "deathsounds/bo2_death.ogg",
                    "deathsounds/aw_death.ogg",
                    "deathsounds/mw2019_death.ogg"
                }
                local fadetbl = {
                    4.5,
                    6,
                    3.6,
                    3,
                    4.5,
                    3,
                    5
                }

                if !deathsound:GetBool() then sndint = math.random(#sndtbl) end
                -- print(sndint, sndtbl[sndint])
                ply:EmitSound(sndtbl[sndint] or 1)

                if screenfadeout:GetBool() then 
                    ply:ScreenFade(SCREENFADE.OUT, Color( 0, 0, 0, 255 ), fadetbl[sndint] or 4.5, 100)
                end

                if deathcamera_effect:GetBool() then
                    hook.Add( "CalcView", "COD_Deathcamera", function(ply)
                        
                        local ply_ragdoll = ply:GetObserverTarget()
                        if !IsValid(ply_ragdoll) then ply_ragdoll = ply:GetRagdollEntity() end
                        local pos, ang = ply:GetPos()+Vector(0,0,8), ply:EyeAngles()
                        local view = {}
                        if deathcamera_effect:GetInt() == 1 then
                            ang = ply:EyeAngles() + Angle(-5,0,40)
                        end
                        if ply_ragdoll and IsValid(ply_ragdoll) and !ply_ragdoll:IsPlayer() and ply_ragdoll.SetNoDraw then 
                            ply_ragdoll:SetNoDraw(true) 
                            pos = ply_ragdoll:GetBonePosition(0) + Vector(0, 0, 5)
                        else return end
                        view.origin = pos
                        view.angles = ang
                        
                        return view
                    end)
                end

                local scrw, scrh, start = ScrW(), ScrH(), SysTime()
                local alphalerp
                local flash
                local start_flash = SysTime()

                -- Adds the main text on screen
                hook.Add("HUDPaint", "HOOK_COD_DEATH_QUOTES", function()
                    alphalerp = Lerp( math.Clamp(SysTime() - start, 0, 1.75), 0, 255 )
                    draw.DrawText(quote, "COD_DEATH_QUOTEFONT", scrw * 0.5, scrh * 0.4, Color(255,255,255, alphalerp ), TEXT_ALIGN_CENTER)
                end)

                -- Add some nice Post-processing effects
                if blureffects:GetBool() then
                    hook.Add("RenderScreenspaceEffects", "COD_MotionBlurEffects", function()
                        DrawMotionBlur(0.1, 0.9, 0 )
                        DrawToyTown( 1, ScrH() )
                    end)
                end

                -- Create a "reminder" message after fading to black.
                timer.Create("COD_DEATHNOISE_AMB", fadetbl[sndint], 1, function ()
                    ply:EmitSound("deathsounds/deathstinger" .. math.random(4) .. ".ogg")
                    hook.Add("HUDPaint", "HOOK_COD_DEADREMINDER", function()
                        surface.SetDrawColor( 0, 0, 0, 136 )
                        surface.DrawRect( 1145, 858, 400, 40 ) -- Creates a rectangle box to cover behind the remind text, for style I suppose.
                        flash = Lerp( math.Clamp(SysTime() - start_flash, 0, 0.65), 0, 255 )
                        if SysTime() - start_flash > 0.65 then -- Makes the reminder text flash
                            start_flash = SysTime()
                        end
                        draw.DrawText("Press JUMP or MOUSE 1 to respawn!", "CloseCaption_Bold", scrw * 0.6, scrh * 0.8, Color(239,255,0, flash))
                    end)
                end)
            end
        end

        gameevent.Listen("player_spawn")
        hook.Add( "player_spawn", "COD_DEATHSCREEN_RESPAWN", function( data ) 
            if hook.GetTable().CalcView.COD_Deathcamera != nil then
                hook.Remove("CalcView", "COD_Deathcamera")
            end
            -- Remove hooks upon spawning
            hook.Remove("RenderScreenspaceEffects", "COD_MotionBlurEffects")
            hook.Remove("HUDPaint", "HOOK_COD_DEATH_QUOTES")
            hook.Remove("HUDPaint", "HOOK_COD_DEADREMINDER")
            -- Stop all sounds upon spawning (A better way to stop sounds?)
            LocalPlayer():StopSound("deathsounds/deathstinger1.ogg")
            LocalPlayer():StopSound("deathsounds/deathstinger2.ogg")
            LocalPlayer():StopSound("deathsounds/deathstinger3.ogg")
            LocalPlayer():StopSound("deathsounds/deathstinger4.ogg")
            LocalPlayer():StopSound("deathsounds/mw2_death.ogg")
            LocalPlayer():StopSound("deathsounds/cod3_death1.ogg")
            LocalPlayer():StopSound("deathsounds/cod3_death2.ogg")
            LocalPlayer():StopSound("deathsounds/cod3_death3.ogg")
            LocalPlayer():StopSound("deathsounds/cod3_death4.ogg")
            LocalPlayer():StopSound("deathsounds/cod3_death5.ogg")
            LocalPlayer():StopSound("deathsounds/waw_death1.ogg")
            LocalPlayer():StopSound("deathsounds/waw_death2.ogg")
            LocalPlayer():StopSound("deathsounds/bo1_death.ogg")
            LocalPlayer():StopSound("deathsounds/bo2_death.ogg")
            LocalPlayer():StopSound("deathsounds/aw_death.ogg")
            LocalPlayer():StopSound("deathsounds/mw2019_death.ogg")
            -- Stops the timer
            timer.Stop("COD_DEATHNOISE_AMB")
        end)
    end)
end

--[[ function SaveToJson()
    if !file.Exists("",'DATA') then
        file.CreateDir("")
    end
    file.Write("")
end ]]--