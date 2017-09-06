/obj/structure/decorative/vendomat
    name = "broken_vend"
    icon = 'icons/obj/broken_vend.dmi'
    icon_state = "coffe-broken"

/obj/structure/decorative/vendomat/attackby(obj/item/weapon/W, mob/user)
    if(istype(W, /obj/item/weapon/wrench))
        playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
        if(anchored)
            user.visible_message("[user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
        else
            user.visible_message("[user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

        if(do_after(user, 20, src))
            if(!src) return
            user << "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>"
            anchored = !anchored