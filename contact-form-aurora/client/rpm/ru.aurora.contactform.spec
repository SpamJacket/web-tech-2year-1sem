Name:       ru.aurora.contactform
Summary:    Contact Form for Aurora OS
Version:    1.0.0
Release:    1
License:    MIT
URL:        https://github.com/user/contact-form-aurora
Source0:    %{name}-%{version}.tar.bz2

Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(auroraapp)
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5WebSockets)
BuildRequires:  desktop-file-utils

%description
Contact form application for Aurora OS that communicates with 
a WebSocket server for form validation.

%prep
%setup -q -n %{name}-%{version}

%build
%qmake5
%make_build

%install
%qmake5_install

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
