#!/bin/bash

echo "" >/tmp/containersIDlist.tmp
echo "" >/tmp/zombieProclist.tmp

#def_arrary_list
a_containersIDlist=($(docker ps | grep -vE "POD|logclean|monitoring|dce|kube" | awk 'NR >1{print $1}'))
a_zombieProclist=($(ps -A -ostat,ppid,pid,cmd | grep -e '^[Zz]' | awk '{print $2}'| sort | uniq))


#def_collect_containerINFO_function

f_containersPidlist(){

        for i in ${a_containersIDlist[@]};
        do
                docker inspect $i | jq -r '[.[].State.Pid,.[].Config.Hostname,.[].Name] | @tsv' | awk -F "_" '{print $1,$4}' | awk '{print $1,$2,$4}' >>/tmp/containersIDlist.tmp
                docker inspect $i | jq -r .[].State.Pid
        done

}

f_containersPidlist > /dev/null

#def_main_function_diff_zombiePID_and_containerID

f_main(){

        local v_zombieProcNumbers=$(ps -A -ostat,ppid,pid,cmd | grep -e '^[Zz]' | awk '{print $2}'| wc -l)

        if [ "$v_zombieProcNumbers" -gt 0 ];
        then
                echo -e "zombieProcNumbers: \033[41;37m $v_zombieProcNumbers \033[0m"
                ps -A -ostat,ppid,pid,cmd | grep -e '^[Zz]' >>/tmp/zombieProclist.tmp
        else
                echo -e "\033[42;37m node_is_not_zombie_proceess!!! \033[0m"
        fi


    for az in ${a_zombieProclist[@]};
    do
          cat /tmp/containersIDlist.tmp | grep $az >/dev/null
                  if [ $? -eq 0 ];
                  then
                      cat /tmp/containersIDlist.tmp | grep $az
                  fi
    done
}

f_main
