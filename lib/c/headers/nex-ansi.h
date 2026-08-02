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

#endif

