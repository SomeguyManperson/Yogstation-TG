/datum/component/cognitohazard
  var/brain_damage = 1
  var/other_effect = NONE
  var/cooldown = 50
  var/last_process = 0

/datum/component/cognitohazard/initialize(_brain_damage, _other_effect)
  brain_damage = _brain_damage
  other_effect = _other_effect

/datum/component/cognitohazard/proccess()
  for(var/mob/living/L in viewers(7, src))
    if(L.has_trait(IS_BLIND)) //later: make auditory hazards
      return
    if(istype(L.get_item_by_slot(SLOT_HEAD), /obj/item/clothing/head/foilhat)
      to_chat(L, "<span class='warning'>You feel something trying to get inside your head, good thing you're wearing that hat!</span>")
      return
  if(ishuman(L)
    L.adjustBrainLoss(brain_damage)
  if(other_effect)
    do_other_effect(L)
  if(last_process + cooldown < world.time)
    to_chat(L, "<span class='warning'>You feel something inside your head...</span>")
    last_process = world.time

/datum/component/cognitohazard/proc/do_other_effect(mob/living/L)
  if(other_effect == "orange")
    if(last_process + cooldown < world.time)
      to_chat(L, "<span class='warning'>You feel something orange closing off your thoughts...</span>")
      last_proccess = world.time
    if(L.stat == CONSCIOUS && prob(5))
      flash_color(L, flash_color = list("#FFA500", "#FFA500", "#FFA500", rgb(0,0,0)), flash_time = 50)
      L.say(pick("ORANGE MAN BAD!!", "4dplanner ir orange man salt!!", "reality cannot limit me anymore!!", "Rivert slip nerf!!", "DEBASE WEN!!")) //please i need more jokes
