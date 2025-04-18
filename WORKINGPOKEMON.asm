.macro effectiveness %x, %y, %z, %a
    # Arguments:
    # %x = pokemon 1 type (attacker)
    # %y = pokemon 2 first type (defender)
    # %z = pokemon 2 second type (defender)
    # %a = final score register
    la s0, types
    li s1, 2
    la s2, one
    flw fs6, 0(s2)
    li s3, -1
    mv s4, %x
    mv s5, %y
    mv s6, %z
    
loop:
    beq %x, s3, noType
    beq %y, s3, nextType
    li s7, 18
    mul s8, %x, s7
    add s8, s8, %y
    li s9, 4
    mul s8, s8, s9
    add s8, s8, s0
    flw fs5, 0(s8)
    fmul.s fs6, fs6, fs5
    
nextType:
    mv %y, %z
    addi s1, s1, -1
    beqz s1, end
    li %z, -1
    j loop
    
noType: 
    fmv.s.x fs6, zero
    
end:
    fmv.s %a, fs6
    # Restoring registers
    mv %x, s4
    mv %y, s5
    mv %z, s6
.end_macro

.macro getPokemon %x, %y, %z
    # %x = index of the Pokémon
    # %y = register to store the primary type
    # %z = register to store the secondary type
    mv s9, %x
    li s6, 1
    la s0, pokemon
    sub %x, %x, s6

    li s2, 8
    mul s3, %x, s2

    add s4, s0, s3
    lw %y, 0(s4)
    lw %z, 4(s4)
    mv %x, s9
.end_macro

.macro printDec (%x)
    li a7, 1
    mv a0, %x
    ecall
.end_macro

.macro getDec (%x)
    li a7, 5
    ecall
    mv %x, a0
.end_macro

.macro divide %x, %y, %z
    fmv.s %z, %x
    fadd.s %z, %z, %y
    la s1, divider
    flw fs1, 0(s1)
    fdiv.s %z, %z, fs1
.end_macro

.data
prompt1: .asciz "\nInput first Pokemon index: "
prompt2: .asciz "\nInput second Pokemon index: "
winner: .asciz "\nWinner: "
tie: .asciz "\n\nIt's a tie"

pokemon:
# -1 if the pokemon doesn't have a secondary typing
# and the numerical equivalent of the types can be seen in the type effectiveness matrix.

    .word 11, 3   # 001 Bulbasaur (Grass, Poison)
    .word 11, 3   # 002 Ivysaur (Grass, Poison)
    .word 11, 3   # 003 Venusaur (Grass, Poison)
    .word 9, -1   # 004 Charmander (Fire, None)
    .word 9, -1   # 005 Charmeleon (Fire, None)
    .word 9, 2    # 006 Charizard (Fire, Flying)
    .word 11, -1  # 007 Squirtle (Water, None)
    .word 11, -1  # 008 Wartortle (Water, None)
    .word 11, -1  # 009 Blastoise (Water, None)
    .word 7, -1   # 010 Caterpie (Bug, None)
    .word 7, -1   # 011 Metapod (Bug, None)
    .word 7, 6    # 012 Butterfree (Bug, Flying)
    .word 7, 3    # 013 Weedle (Bug, Poison)
    .word 7, 3    # 014 Kakuna (Bug, Poison)
    .word 7, 3    # 015 Beedrill (Bug, Poison)
    .word 0, 6    # 016 Pidgey (Normal, Flying)
    .word 0, 6    # 017 Pidgeotto (Normal, Flying)
    .word 0, 6    # 018 Pidgeot (Normal, Flying)
    .word 0, -1   # 019 Rattata (Normal, None)
    .word 0, -1   # 020 Raticate (Normal, None)
    .word 0, 6    # 021 Spearow (Normal, Flying)
    .word 0, 6    # 022 Fearow (Normal, Flying)
    .word 3, -1   # 023 Ekans (Poison, None)
    .word 3, -1   # 024 Arbok (Poison, None)
    .word 12, -1  # 025 Pikachu (Electric, None)
    .word 12, -1  # 026 Raichu (Electric, None)
    .word 4, -1   # 027 Sandshrew (Ground, None)
    .word 4, -1   # 028 Sandslash (Ground, None)
    .word 3, -1   # 029 Nidoran? (Poison, None)
    .word 3, -1   # 030 Nidorina (Poison, None)
    .word 3, 4    # 031 Nidoqueen (Poison, Ground)
    .word 3, -1   # 032 Nidoran? (Poison, None)
    .word 3, -1   # 033 Nidorino (Poison, None)
    .word 3, 4    # 034 Nidoking (Poison, Ground)
    .word 0, -1   # 035 Clefairy (Normal, None)
    .word 0, -1   # 036 Clefable (Normal, None)
    .word 9, -1   # 037 Vulpix (Fire, None)
    .word 9, -1   # 038 Ninetales (Fire, None)
    .word 0, -1   # 039 Jigglypuff (Normal, None)
    .word 0, -1   # 040 Wigglytuff (Normal, None)
    .word 3, 6    # 041 Zubat (Poison, Flying)
    .word 3, 6    # 042 Golbat (Poison, Flying)
    .word 11, 3   # 043 Oddish (Grass, Poison)
    .word 11, 3   # 044 Gloom (Grass, Poison)
    .word 11, 3   # 045 Vileplume (Grass, Poison)
    .word 7, 11   # 046 Paras (Bug, Grass)
    .word 7, 11   # 047 Parasect (Bug, Grass)
    .word 7, 3    # 048 Venonat (Bug, Poison)
    .word 7, 3    # 049 Venomoth (Bug, Poison)
    .word 4, -1   # 050 Diglett (Ground, None)
    .word 4, -1   # 051 Dugtrio (Ground, None)
    .word 0, -1   # 052 Meowth (Normal, None)
    .word 0, -1   # 053 Persian (Normal, None)
    .word 11, -1  # 054 Psyduck (Water, None)
    .word 11, -1  # 055 Golduck (Water, None)
    .word 1, -1   # 056 Mankey (Fighting, None)
    .word 1, -1   # 057 Primeape (Fighting, None)
    .word 9, -1   # 058 Growlithe (Fire, None)
    .word 9, -1   # 059 Arcanine (Fire, None)
    .word 11, -1  # 060 Poliwag (Water, None)
    .word 11, -1  # 061 Poliwhirl (Water, None)
    .word 11, 1   # 062 Poliwrath (Water, Fighting)
    .word 14, -1  # 063 Abra (Psychic, None)
    .word 14, -1  # 064 Kadabra (Psychic, None)
    .word 14, -1  # 065 Alakazam (Psychic, None)
    .word 1, -1   # 066 Machop (Fighting, None)
    .word 1, -1   # 067 Machoke (Fighting, None)
    .word 1, -1   # 068 Machamp (Fighting, None)
    .word 11, 3   # 069 Bellsprout (Grass, Poison)
    .word 11, 3   # 070 Weepinbell (Grass, Poison)
    .word 11, 3   # 071 Victreebel (Grass, Poison)
    .word 11, 3   # 072 Tentacool (Water, Poison)
    .word 11, 3   # 073 Tentacruel (Water, Poison)
    .word 5, 4    # 074 Geodude (Rock, Ground)
    .word 5, 4    # 075 Graveler (Rock, Ground)
    .word 5, 4    # 076 Golem (Rock, Ground)
    .word 9, -1   # 077 Ponyta (Fire, None)
    .word 9, -1   # 078 Rapidash (Fire, None)
    .word 11, 14  # 079 Slowpoke (Water, Psychic)
    .word 11, 14  # 080 Slowbro (Water, Psychic)
    .word 12, -1  # 081 Magnemite (Electric, None)
    .word 12, -1  # 082 Magneton (Electric, None)
    .word 9, -1   # 083 Farfetch'd (Normal, Flying)
    .word 9, -1   # 084 Doduo (Normal, Flying)
    .word 9, 6    # 085 Dodrio (Normal, Flying)
    .word 3, -1   # 086 Seel (Water, None)
    .word 3, 14   # 087 Dewgong (Water, Ice)
    .word 9, 4    # 088 Grimer (Poison, None)
    .word 9, 4    # 089 Muk (Poison, None)
    .word 11, -1  # 090 Shellder (Water, None)
    .word 11, 14  # 091 Cloyster (Water, Ice)
    .word 7, 4    # 092 Gastly (Ghost, Poison)
    .word 7, 4    # 093 Haunter (Ghost, Poison)
    .word 7, 4    # 094 Gengar (Ghost, Poison)
    .word 5, 4    # 095 Onix (Rock, Ground)
    .word 11, -1  # 096 Drowzee (Psychic, None)
    .word 11, 14  # 097 Hypno (Psychic, None)
    .word 11, -1  # 098 Krabby (Water, None)
    .word 11, 6   # 099 Kingler (Water, None)
    .word 12, -1  # 100 Voltorb (Electric, None)

types:
    .float 1.0,1.0,1.0,1.0,1.0,0.5,1.0,0.0,0.5,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,	# 0 Normal
    .float 2.0,1.0,0.5,0.5,1.0,2.0,0.5,0.0,2.0,1.0,1.0,1.0,1.0,0.5,2.0,1.0,2.0,0.5,	# 1 Fighting
    .float 1.0,2.0,1.0,1.0,1.0,0.5,2.0,1.0,0.5,1.0,1.0,2.0,0.5,1.0,1.0,1.0,1.0,1.0,	# 2 Flying 
    .float 1.0,1.0,1.0,0.5,0.5,0.5,1.0,0.5,0.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,2.0,	# 3 Poison
    .float 1.0,1.0,0.0,2.0,1.0,2.0,0.5,1.0,2.0,2.0,1.0,0.5,2.0,1.0,1.0,1.0,1.0,1.0,	# 4 Ground
    .float 1.0,0.5,2.0,1.0,0.5,1.0,2.0,1.0,0.5,2.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,	# 5 Rock
    .float 1.0,0.5,0.5,0.5,1.0,1.0,1.0,0.5,0.5,0.5,1.0,2.0,1.0,2.0,1.0,1.0,2.0,0.5,	# 6 Bug
    .float 0.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,0.5,1.0,	# 7 Ghost
    .float 1.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,0.5,0.5,0.5,1.0,0.5,1.0,2.0,1.0,1.0,2.0,	# 8 Steel
    .float 1.0,1.0,1.0,1.0,1.0,0.5,2.0,1.0,2.0,0.5,0.5,2.0,1.0,1.0,2.0,0.5,1.0,1.0,	# 9 Fire
    .float 1.0,1.0,1.0,1.0,2.0,2.0,1.0,1.0,1.0,2.0,0.5,0.5,1.0,1.0,1.0,0.5,1.0,1.0,	# 10 Water
    .float 1.0,1.0,0.5,0.5,2.0,2.0,0.5,1.0,0.5,0.5,2.0,0.5,1.0,1.0,1.0,0.5,1.0,1.0,	# 11 Grass
    .float 1.0,1.0,2.0,1.0,0.0,1.0,1.0,1.0,1.0,1.0,2.0,0.5,0.5,1.0,1.0,0.5,1.0,1.0,	# 12 Electric
    .float 1.0,2.0,1.0,2.0,1.0,1.0,1.0,1.0,0.5,1.0,1.0,1.0,1.0,0.5,1.0,1.0,0.0,1.0,	# 13 Psychic
    .float 1.0,1.0,2.0,1.0,2.0,1.0,1.0,1.0,0.5,0.5,0.5,2.0,1.0,1.0,0.5,2.0,1.0,1.0,	# 14 Ice
    .float 1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.5,1.0,1.0,1.0,1.0,1.0,1.0,2.0,1.0,0.0,	# 15 Dragon
    .float 1.0,0.5,1.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,0.5,0.5,	# 16 Dark
    .float 1.0,2.0,1.0,0.5,1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,2.0,2.0,1.0	# 17 Fairy   


divider: .float 2.0

one: .float 1.0

.text
.globl _start
_start:
    li a7, 4
    la a0, prompt1
    ecall

    getDec t0
    
    li a7, 4
    la a0, prompt2
    ecall

    getDec t1
    
    getPokemon t0, a1, a2
    getPokemon t1, a3, a4   
    
    effectiveness a1, a3, a4, fa1
    effectiveness a2, a3, a4, fa2
    effectiveness a3, a1, a2, fa3
    effectiveness a4, a1, a2, fa4
    
    bgez a1, check1
    j next_check
    
check1:
    bgez a2, divide1
    fadd.s fa6, fa1, fa2
    j next_check
    
divide1:
    divide fa1, fa2, fa6
    
next_check:
    bgez a3, check2
    j compare
    
check2:
    bgez a4, divide2
    fadd.s fa7, fa3, fa4
    j compare
    
divide2:
    divide fa3, fa4, fa7
    
compare:
    flt.s a5, fa7, fa6
    bnez a5, winner_1
    flt.s a5, fa6, fa7
    bnez a5, winner_2
    j tied
    
winner_1:
    li a7, 4
    la a0, winner
    ecall
    printDec t0
    j end
    
winner_2:
    li a7, 4
    la a0, winner
    ecall
    printDec t1
    j end
    
tied:
    li a7, 4
    la a0, winner
    ecall
    
    li a0, -1
    printDec a0
    
    li a7, 4
    la a0, tie
    ecall
    
end:
    li a7, 93
    ecall