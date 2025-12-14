import QtQuick 2.6
import Sailfish.Silica 1.0
import ContactFormServer 1.0
import "pages"

ApplicationWindow {
    id: appWindow
    
    initialPage: Component { AdminPage { } }
    cover: undefined
    
    allowedOrientations: defaultAllowedOrientations
}

