/*1.找到了比它更便宜的加油站，秉持着加最便宜的油的想法，我们只要有跑到那个更便宜的加油站的油就行了。
2.找不到比它更便宜的油站，那这时候最便宜的油就是自己了，所以我们加满油再跑到价格仅次于我们油站的油站
3.最尴尬的情况就是，在这个距离内我找不到任何一个油站了，意味着就算我加满油也跑不到下一个油站，
所以这个时候直接结束，最大距离就是我们现在的距离加最远距离。
*/
#include<algorithm>
#include<cstdio>
#include<iostream>
using std::pair;
using std::sort;
pair<int,double> tank[505];
int C_max,D,D_avg,N,current_station = 0;
double current_dist,current_oil,current_price = 0.0;
int main()
{
    scanf("%d%d%d%d",&C_max,&D,&D_avg,&N);
    for(int i = 0;i < N;i++)
    {
        scanf("%lf%d",&tank[i].second,&tank[i].first);
    }
    //printf("%d",tank[0].first);
    tank[N] = pair<int,double>(D,0);
    sort(tank,tank + N + 1);
    int max_dis = C_max * D_avg;
    if(tank[0].first != 0)
    {
        printf("The maximum travel distance = 0.00\n");
        return 0;
    }
    
    // 从当前的加油站出发，搜索max_dis范围内的加油站
    while (current_dist < D)
    {
        int next_station = 0; // 下一个最便宜的加油站
        int next_cheapest = current_station + 1; // 下一个第二便宜的加油站
        // int next_closest = current_station + 1; // 下一个最近的加油站
        for(int i = current_station + 1;i <= N && tank[i].first<= current_dist + max_dis;i++) // 从当前加油站开始搜索
        {
            if(tank[i].second <= tank[current_station].second)//找到比当前更便宜的就停下来，这是贪婪的策略
            {
                next_station = i;
                break;
            }
            if(tank[i].second <= tank[next_cheapest].second)
            {
                next_cheapest = i;
            }
        }
        // 找到最便宜的了，就加刚好到那里的油
        if(next_station > 0){ //
            current_price += ((tank[next_station].first - current_dist) / D_avg - current_oil)* tank[current_station].second;
            current_dist = tank[next_station].first;
            current_station = next_station;
            current_oil = 0;
        }else if(tank[next_cheapest].first - current_dist <= max_dis) //自己就是最便宜的，那就给自己加满
        {
            current_price += (C_max - current_oil) * tank[current_station].second;
            current_oil = C_max - (tank[next_cheapest].first - current_dist) / D_avg;
            current_dist = tank[next_cheapest].first;
            current_station = next_cheapest;
        }else{ 
            current_dist += max_dis;
            printf("The maximum travel distance = %.2f\n",current_dist);
            return 0;
        }
    }
    printf("%.2f\n",current_price);
    return 0;
    

}