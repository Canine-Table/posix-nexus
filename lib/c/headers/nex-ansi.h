#ifndef nx_Dm_ansi_H
#define nx_Dm_ansi_H

void nx_ansi_success(const char *fmt, ...);
void nx_ansi_error(const char *fmt, ...);
void nx_ansi_warning(const char *fmt, ...);
void nx_ansi_alert(const char *fmt, ...);
void nx_ansi_debug(const char *fmt, ...);
void nx_ansi_info(const char *fmt, ...);
void nx_ansi_light(const char *fmt, ...);
void nx_ansi_dark(const char *fmt, ...);

#define NEX_err_M(fmt, ...) \
    nx_ansi_error("[%s:%d] " fmt, __FILE__, __LINE__, ##__VA_ARGS__)

#define NEX_warning_M(fmt, ...) \
    nx_ansi_warning("[%s:%d] " fmt, __FILE__, __LINE__, ##__VA_ARGS__)

#define NEX_ansiPrefix_M(color, symbol) \
        fprintf(stderr, color "[" "\x1b[4;3;7m" symbol "\x1b[24;23;27m" "]" "\x1b[37m: " color)

#define NEX_ansiSuffix_M() \
        fprintf(stderr, "\x1b\[0m")


#endif

