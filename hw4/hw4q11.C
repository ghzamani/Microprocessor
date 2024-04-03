#include <stdio.h>
#include <dos.h>

int *convert_data(long gy, long gm, long gd, int result[]) {
  long jy, gy2, days, g_d_m[12] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
  gy2 = (gm > 2) ? (gy + 1) : gy;
  days = 355666 + (365 * gy) + ((int)((gy2 + 3) / 4)) - ((int)((gy2 + 99) / 100)) + ((int)((gy2 + 399) / 400)) + gd + g_d_m[gm - 1];
  jy = -1595 + (33 * ((int)(days / 12053)));
  days %= 12053;
  jy += 4 * ((int)(days / 1461));
  days %= 1461;
  if (days > 365) {
    jy += (int)((days - 1) / 365);
    days = (days - 1) % 365;
  }
  result[0] =(int) jy;
  if (days < 186) {
    result[1]/*jm*/ = 1 + (int)(days / 31);
    result[2]/*jd*/ = 1 + (days % 31);
  } else {
    result[1]/*jm*/ = 7 + (int)((days - 186) / 30);
    result[2]/*jd*/ = 1 + ((days - 186) % 30);
  }
  return result;
}


main()
{
    long year;
    long month;
    long day;
    int result[2];
    union REGS regin,regout;
    regin.h.ah = 0x2A;
    int86(0x21,&regin, &regout);
    day = (long) regout.h.dl;
    month = (long) regout.h.dh;
    year = (long) regout.x.cx;
    convert_data(year, month, day, result);
    printf("data: %d/%d/%d\n", result[0], result[1], result[2]);
    return 0;
}
