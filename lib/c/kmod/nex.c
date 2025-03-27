#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#define PRINT_DEBUG \
       printk (KERN_DEBUG "[% s]: FUNC:% s: LINE:% d \ n", __FILE__,
               __FUNCTION__, __LINE__)

MODULE_DESCRIPTION("posix-nexus kernel modules");
MODULE_AUTHOR("Canine-Table");
MODULE_LICENSE("GPLv3");

static int posix_nexus_init(void)
{
	pr_debug("Hi\n");
	return 0;
}

static void posix_nexus_exit(void)
{
	pr_debug("Bye\n");
}

module_init(posix_nexus_init);
module_exit(posix_nexus_exit);

