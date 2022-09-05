/*
  Copyright (C) 2002-2006 Quantum ESPRESSO group
  This file is distributed under the terms of the
  GNU General Public License. See the file `License'
  in the root directory of the present distribution,
  or http://www.gnu.org/copyleft/gpl.txt .
*/

#if defined(_WIN32)
#include <windows.h>
#include <sys/time.h>
#include <stdint.h>
#else
#include <sys/time.h>
#include <sys/resource.h>
#endif
#include <unistd.h>
#ifdef USE_VEPERF
#include <veperf.h>
#endif

double cclock()

/* Return the second elapsed since Epoch (00:00:00 UTC, January 1, 1970)
*/

{

    struct timeval tmp;
    double sec;
    gettimeofday( &tmp, (struct timezone *)0 );
    sec = tmp.tv_sec + ((double)tmp.tv_usec)/1000000.0;
    return sec;

}

double scnds ( )

/* Return the cpu time associated to the current process 
*/

{
    double sec=0.0;
    return sec;
}

