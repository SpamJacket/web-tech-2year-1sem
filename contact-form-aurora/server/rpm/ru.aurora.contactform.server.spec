Name:       ru.aurora.contactform.server
Summary:    Contact Form Admin Panel Server
Version:    1.0.0
Release:    1
License:    MIT
URL:        https://github.com/user/contact-form-aurora
Source0:    %{name}-%{version}.tar.bz2

BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5WebSockets)
BuildRequires:  pkgconfig(Qt5Network)
BuildRequires:  pkgconfig(Qt5Svg)

%description
WebSocket server with Admin Panel GUI for Contact Form application.
Receives and validates contact form submissions from Aurora OS clients.

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
%{_datadir}/icons/hicolor/*/apps/%{name}.png

