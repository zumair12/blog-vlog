import { controller, registerControllers } from "stimulus-loading"
import { application } from "./application"

// Dropdown controller
import DropdownController from "./dropdown_controller"
application.register("dropdown", DropdownController)

// Navbar controller
import NavbarController from "./navbar_controller"
application.register("navbar", NavbarController)

// Flash controller
import FlashController from "./flash_controller"
application.register("flash", FlashController)

// Reply toggle controller
import ReplyToggleController from "./reply_toggle_controller"
application.register("reply-toggle", ReplyToggleController)
