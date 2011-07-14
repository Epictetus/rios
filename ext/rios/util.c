#include "util.h"
#include <pty.h>

VALUE Rios = Qnil;
VALUE Util = Qnil;

void Init_util() {
    Rios = rb_define_module("Rios");
    Util = rb_define_module_under(Rios, "Util");
    /* rb_define_method(Util, "openpty", method_openpty, 1); */
    rb_define_singleton_method(Util, "openpty", method_openpty, 1);
}

/* Rios::Util::openpty */
VALUE method_openpty(VALUE self, VALUE fd) {
    int master;
    int slave;
    struct termios tt;
    struct winsize win;
    int fd_i = NUM2INT(fd);

    tcgetattr(fd_i, &tt);
    ioctl(fd_i, TIOCGWINSZ, &win);

    openpty(&master, &slave, NULL, &tt, &win);

    return rb_ary_new3(2, INT2NUM(master), INT2NUM(slave));
}