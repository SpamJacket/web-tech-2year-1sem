import QtQuick 2.6
import Sailfish.Silica 1.0
import ContactForm 1.0
import "pages"

ApplicationWindow {
    id: appWindow
    
    initialPage: Component { ContactPage { } }
    cover: undefined
    
    allowedOrientations: defaultAllowedOrientations
}
