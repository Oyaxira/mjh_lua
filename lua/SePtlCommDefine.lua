-- auto make by Tool ProtocolMaker don't modify anything!!!  this file define enum value

--to C++ enum [SeShareDef] Define BEGIN
SSD_MSANGO_MAGIC = 1297303375           --��¼���
SSD_MAX_SEND_SIZE = 7 * 1024            --���η�������������С
SSD_SEND_SIZE = 64 * 1024               --�������緢��ʹ��(���첻�������ݰ�)
SSD_PRASER_SIZE = 1024 * 1024           --�����������Ļ���
SSD_ENDSTR_LEN = 4                      --�ַ�����
SSD_EN_KEY_LEN = 4                      --����Կ�׳���
SSD_IP_LEN = 16                         --IP��ַ����
SSD_STATE_NAME_LEN = 64                 --��������
SDD_MSG_LEN = 128                       --��Ϣ����
SSD_ORDER_LEN = 24                      --��ֵ��������
SDD_SHOW_NOTICE_LEN = 1024              --ͨ����ʾ��Ϣ
SSD_PATH_LEN = 256                      --��־�ļ�·������
SSD_GAME_DUMP_INDEX_NUM = 32            --�����̼߳�¼�����
SSD_MAX_PLAYER_INFO_COUNT = 100         --����ɫ��Ϣ����
SSD_TIME_STRING_LEN = 19                --ʱ���ַ�������
SSD_MAX_SMALL_INT_NUM = 60000           --16λ�������ķ�Χ
SSD_MAX_INT_NUM = 2000000000            --INT��ֵ���ķ�Χ
SSD_INSERT_MAX_STRING_LEN = 4 * 1024    --�����������ַ�������󳤶�
SSD_LOGICTOCLIENT_MAXSIZE = 1 * 1024    --�ͻ������е���Ϣ��󳤶�
SSD_LOGIN_CHECK_LEN = 32                --�汾����󳤶�
SSD_MAX_PUBLIC_LOGIN_TOKEN_LEN = 512    --������¼��token���
SSD_MAX_PUBLIC_LOGIN_URL_LEN = 256      --������¼��URL���
SSD_MAX_PUBLIC_APPID_LEN = 64           --������¼��appid���
SSD_MAX_IMG_STR_LEN = 128               --ͼƬ�����ַ�����󳤶�
SSD_MAX_SERVER_ALIAS_STR_LEN = 32       --������������󳤶�
SSD_MAX_JWT_TOKEN_STR_LEN = 512         --JWTToken��󳤶�
SSD_MAX_COMMON_LOG_NAME_STR_LEN = 128   --��־����󳤶�
SSD_MAX_COMMON_LOG_CONTENT_STR_LEN = 8 * 1024--������־������󳤶�
SSD_MAX_DISPLAY_LOG_CONTENT_STR_LEN = 2048--�籾������־������󳤶�
SSD_MAX_DEBUG_FUNCCALL_NAME = 64        --��������������Ƴ���
SSD_MAX_DEBUG_FUNCCALL_NUMS = 30        --������Ӱ��Ч�ʵ�30������
SSD_ONE_MONTH_TOTAL_SEC_NUMS = 31 * 24 * 60 * 60--һ��31������
SSD_RESYNC_ONLINE_NUMS = 500            --��������ʱÿ��ͬ�����������
SSD_MAX_ITEM_ARRAY_NUMS = 200           --��Ŀ�����������
SSD_EXCHAGE_GOLD_TO_SILVER = 10         --�𶧶һ���������
SSD_MAX_BIG_CMD_BATCH_SIZE = 10240      --��������С
SSD_MAX_CLIENT_RECONTENT_INTERVAL = 5   --�ͻ����������(��)
SSD_MAX_CHATCONTENT_SIZE = 512          --ȫ���������ݳ���
SSD_MAX_REDPACKETUIDSTR_SIZE = 128      --���UID����
SSD_MAX_REDPACKETWORD_SIZE = 128        --��������
SSD_MAX_REDPACKETLIST_SIZE = 4096       --����б���
SSD_MAX_REDPACKETLIMIT_SIZE = 10        --�����
SSD_MAX_GETREDPACKETTIMES = 5           --���ÿ�����ȡ�����
SSD_MAX_USER_SUGGESTION_ERRORINFO_LEN = 256--��ұ�����ԭ���ϱ�����
SSD_MAX_SYSTEMSWITCH_SIZE = 20          --ϵͳ��������
SSD_MAX_MAINTAIN_IP_WHITELIST_NUM = 100 --ά���ڼ䵥��ͬ��IP������������
SSD_MAX_FORBIDREASON_SIZE = 256         --���ԭ�򳤶�
SSD_MAX_HOODLESHOWPLAYER_LEN = 5        --ȫ��С������ʾ����
SSD_MAX_REQHOODLERECORD_LEN = 6         --ȫ��С���ͼ�¼һҳ��������
SSD_HOODLEPOOLBASEVALUE = 10000         --С���ͽ��ػ���idֵ
SSD_MAX_HOODLEPROCESSSHOWPLAYER_LEN = 3 --ȫ��С���ͽ����ƽ���ʾ����
SSD_MAX_HOODLERECORD_MAXLEN = 400       --ȫ��С���Ͳ鿴��ʷ��¼
SSD_MAX_HOODLEITEMTYPE_MAXLEN = 9       --ȫ��С������Ʒ��������
SSD_MAX_HOODLESHOWITEM_MAXLEN = 5       --ȫ��С����չʾ��Ʒ����
SSD_MAX_HOODLEEXCHANGE_MAXLEN = 5       --ȫ��С������Ʒ�һ�����
SSD_MAX_CHANNELNOLEN = 32               --�����ų���
SSD_LIMITSHOP_BIG_GOLD_WORTH = 180      --��ʱ�̵���ӱҼ�ֵ
SSD_LIMITSHOP_FIRST_FREE_SHARE_TIMES = 2--��ʱ�̵��״η�����Ѵ���
SSD_LIMITSHOP_FIRST_FREE_SHARE_GOLD_WORTH = 10--��ʱ�̵��״η������Ľ���
SSD_LIMITSHOP_GAMETYPE = 1              --��ʱ�̵�°��ӱ�����
SSD_MAX_GOLDOPR_PARAMLEN = 2048         --�𶧲����ַ���������󳤶�
SSD_MAX_LIMITSHOPDATA_SIZE = 4096       --��ʱ�̵����ݳ���
SSD_MAX_LIMITSHOPCONDITION_SIZE = 1024  --��ʱ�̵�ˢ�������ַ�������
SSD_MAX_SYSTEM_MODULE_COUNT = 64        --ϵͳģ��ö����������
SSD_MAX_REQ_ACTIVITY_COUNT = 64         --���������Ϣ����
SSD_MAX_PUBLIC_COMMON_JSON_STR_LEN = 1024--����������ͬ��json
SSD_MAX_CLIENT_VERSION_LEN = 64         --�ͻ��˰汾
SSD_MAX_CLIENT_SYSTEM_SOFTWARE_LEN = 64 --�ƶ��ն˲���ϵͳ�汾
SSD_MAX_CLIENT_SYSTEM_HARDWARE_LEN = 64 --�ƶ��ն˻���
SSD_MAX_CLIENT_TELECOMOPER_LEN = 64     --��Ӫ��
SSD_MAX_CLIENT_DENSITY_LEN = 64         --�����ܶ�
SSD_MAX_CLIENT_NET_WORK_LEN = 64        --3G/WIFI/2G/4G/5G
SSD_MAX_CLIENT_CPU_HARDWARE_LEN = 64    --cpu����|Ƶ��|����
SSD_MAX_CLIENT_GL_RENDER_LEN = 64       --opengl render��Ϣ
SSD_MAX_CLIENT_GL_VERSION_LEN = 64      --opengl�汾��Ϣ
SSD_MAX_CLIENT_DEVICEID_LEN = 256       --�豸ID
SSD_MAX_PLAT_AREA = 4                   --ƽ̨���߸���
SSD_MAX_PLAYER_COUNT_PER_PLAT_AREA = 30 --ÿ���������������
SSD_MAX_PLAYER_COUNT_FOR_REQ_PER_PAGE = 5--�ƹ�������ҷ�ҳ������������
SSD_MAX_PLAYER_COUNT_FOR_REQ_FROM_GS = 200--GAS��GSͬ�������Ϣ���������
SSD_BECOME_RMBPLAYER_NEED_GOLD_NUM = 380--��Ϊ���������Ҫ�Ľ���
SSD_MAX_UPDATE_TREASURE_BOOK_TASK_NUM = 50--ÿ�θ��°ٱ���������������
SSD_MAX_UPDATE_TREASURE_BOOK_MALL_NUM = 50--ÿ�θ��°ٱ����̵���Ϣ���������
SSD_MAX_GIVE_FRIEND_ADVANCE_NUM = 20    --ÿ�¿����ͺ���ԤԼ���������
SSD_MAX_TREASURE_TO_MERIDIANSEXP_RATIO = 100--��ĩʣ��ٱ����ҳת��Ϊ��������ı���1:100
SSD_TREASUREBOOK_DIALY_SILVER_BASE_NUM = 50--�ٱ���ÿ����������ֵ
SSD_TREASUREBOOK_DIALY_SILVER_RISE_NUM = 10--�ٱ���ÿ����������ֵ
SSD_TREASUREBOOK_DIALY_SILVER_MAX_NUM = 200--�ٱ���ÿ���������ֵ
SSD_MAX_TLOG_NAME_STR_LEN = 128         --TLog��������󳤶�
SSD_MAX_TLOG_CONTENT_STR_LEN = 4096     --TLog������¼����󳤶�
SSD_MAX_TSS_SDK_PARAM_STR_LEN = 256     --�����ּ�����json��󳤶�
SSD_MAX_TSS_SDK_CONTENT_STR_LEN = 1024  --��������󳤶�
SSD_MAX_GAME_APP_PARAM_STR_LEN = 64     --��ϷAPP����
SSD_MAX_CLIENT_CONTENT_STR_LEN = 4096   --�ϱ��ַ�������󳤶�
SSD_MAX_ANTIADDICTION_RET_INSTRUCTION_JSON_LEN = 1024--�����Է���Json������󳤶�
SSD_MAX_SEC_TSS_REPORT_DATA_LEN = 128   --��ȫ��־TSSSDK�ϱ���Ϣ��󳤶�
SSD_MAX_SEC_TSS_SYNC_CLIENT_DATA_LEN = 33000--��ȫSDKͬ���ͻ�����󳤶ȳ�
SSD_MAX_SEC_TSS_SYNC_CLIENT_EXT_DATA_LEN = 1024--��ȫSDKͬ���ͻ��˶������ݳ��ȳ�
SSD_MAX_SEC_REPORT_CHEAT_TYPE_LEN = 32  --�ٱ�����������
SSD_MAX_SEC_REPORT_CHEAT_CONTENT_LEN = 200--�ٱ�����
SSD_MAX_TSS_SDK_CREDIT_SCORE_PARAM_STR_LEN = 2048--��Ѷ���÷ֲ�ѯ����json��󳤶�
SSD_MAX_SEC_REPORT_CHEAT_DESC_LEN = 25  --�û���д�ľٱ�˵��
SSD_MAX_SEC_REPORT_CHEAT_PIC_URL_LEN = 256--�û���д�ľٱ�ͷ��
SSD_MAX_HEART_PACKAGE_TIME = 10000      --��¼���
SSD_MAX_WS2DB_HEART_PACKAGE_TIME = 20*1000--������ʱ��
SSD_MAX_DISCONNECT_WITH_NO_CLIENT_REPLAY = 60*1000--�������Ӧ������Ͽ�����
SSD_MAX_CLIENT_REBUILD_CONNECT_TIME = 180--�ͻ��������ָ����ʱ��(��)
SSD_MAX_MAIL_APPID_LEN = 64             --�ʼ�APPID��󳤶�
SSD_MAX_MAIL_USERID_LEN = 64            --�ʼ�USERID��󳤶�
SSD_MAX_MAIL_REEIVER_LEN = 64           --�����û���󳤶�
SSD_MAX_MAIL_TITLE_LEN = 128            --������󳤶�
SSD_MAX_MAIL_CONTENT_LEN = 1024         --�ʼ�������󳤶�
SSD_MAX_MAIL_ATTACH_LEN = 512           --������󳤶�
SSD_MAX_MAIL_ATTACH_NUM = 10            --�����������
SSD_MAX_GM_MAIL_SEND_NUM = 1000         --��ָ��������£�GM��ͬʱ�����ʼ�����������
SSD_MAX_MAIL_FILTER_NUM_LEN = 32        --�ʼ��������������ַ����ĳ���
SSD_MAX_GM_MAIL_FILTER_LEN = 256        --�ʼ����������ַ���
SSD_MAX_OPR_MAIL_NUM = 30               --�ͻ��˲����ʼ����������
SSD_MAX_RECEIVE_MAILID_JSON_LEN = 512   --��ȡ�������ʼ�ID����JSON��󳤶�
SSD_MAX_RECEIVERET_MAIL_JSON_LEN = 8192 --������ȡ�ʼ�����JSON��󳤶�
SSD_MIN_ACCOUNT = 4                     --�ʺ�����С����
SSD_MAX_ACCOUNT = 56                    --�ʺ��������
SSD_MIN_PASSWORD = 6                    --������С����
SSD_MAX_PASSWORD = 36                   --������󳤶�
SSD_MAX_LOGINTYPE = 36                  --��½������󳤶�
SSD_MAX_TOKEN = 36                      --��½token��󳤶�
SSD_MAX_MOBILEINFO = 36                 --�ֻ���ʶ��󳤶�
SSD_MAX_DEVICEINDEFY = 64               --�豸Ψһ��ʶ��󳤶�
SSD_MAX_GUEST_ID = 32                   --�ο��˺���󳤶�
SSD_MAX_ACCOUNT_ID = 32                 --�˺�ID��󳤶�
SSD_MAX_OPEN_ID = 64                    --OpenID��󳤶�
SSD_MAX_SYSTEMINFO_LEN = 1024           --������Ϣ��󳤶�
SSD_MAX_OPEN_KEY = 256                  --OpenKey��󳤶�
SSD_MAX_PF_KEY = 128                    --pfKey��󳤶�
SSD_MAX_BILLNO_LEN = 64                 --BillNO��󳤶�
SSD_MIN_CHAR_NAME = 2                   --��ɫ����С����
SSD_MAX_CHAR_NAME = 32                  --��ɫ����󳤶�
SSD_MAX_SHOW_CHAR_NAME = 16             --��ɫ�������ʾ����
SSD_MAX_RECON_TIME_RACE = 3 * 60 * 1000 --���ֶ�����������ʱ��
SSD_MAX_ROLE_TITLE = 32                 --��ɫ�ƺ����̶�
SSD_MAX_ROLE_ITEM_CAP_NUMS = 2000       --��ұ����������
SSD_MAX_ROLE_ITEM_NUMS = 100            --��ұ����������
SSD_MAX_ROLE_TEAMMATES_NUMS = 200       --��Ҷ����������
SSD_MAX_INVITE_TEAMMATES_NUMS = 100     --�����������������
SSD_MAX_ITEM_ATTR_NUMS = 20             --��Ʒ���������������
SSD_MAX_CREATEROLE_ATTR_NUMS = 30       --������������
SSD_MAX_CREATEROLE_NUMS = 50            --�ɴ����������
SSD_MAX_DISPOSITIONS_NUMS = 50          --�������͵ĺøж��������
SSD_MAX_ROLE_GIFT_NUMS = 100            --��ɫ�츳�������
SSD_MAX_TAG_NUMS = 1000                 --����������
SSD_MAX_ROLE_WISHTASKS_NUMS = 20        --��ɫ��Ը�������
SSD_MAX_ROLE_MARTIAL_NUMS = 50          --��ɫ��ѧ�������
SSD_MAX_ROLE_DISPLAYATTR_NUMS = 100     --��ɫ��ʾ�����������
SSD_MAX_ROLE_GUANCA_NUMS = 400          --��ɫ�۲������ʾ�����������
SSD_MAX_NPC_ITEM_NUMS = 36              --NPC�����������
SSD_MAX_APPEARANCE_LEN = 36             --�޸�����������
SSD_RENAME_COST_GOLD_NUM = 100          --�����۳��Ľ���
SSD_RENAME_COST_SILVER_NUM = 1000       --�����۳��Ľ���
SSD_MAX_ROLE_FAVOR_NUM = 5              --��ɫϲ���������
SSD_MAX_ROLE_BROANDSIS_NUM = 100        --��ɫ��������
SSD_MAX_ROLE_INTERACT_USED_NUM_LEN = 128--�д�Ƚ�ɫ����ʹ�ô����ַ��洢���
SSD_MAX_ROLE_COMMON_INFO_LEN = 64       --ͨ����Ϣ��ѯ���
SSD_MAX_ROLE_PETS_NUM = 20              --��ҳ�������
SSD_MAX_UNLOCKDISGUISE_NUMS = 100       --���������������
SSD_MAX_CANNOTLEAVE_NUMS = 10           --��������������
SSD_MAX_CANNOTLEAVE_LENGTH = 128        --��������ֶ���󳤶�
SSD_RANDOMGIFT_COUNT = 3                --����츳����
SSD_RANDOMWISHTTASKREWARD_COUNT = 3     --�����Ը����
SSD_MAX_ROLE_SKIN = 20                  --ÿ�����ǽ�ɫ���Ƥ����
SSD_CREATGIFT_COUNT = 3                 --�����츳����
SSD_MAX_ROLE_CONTACT_ROW_NUM = 3        --���н�ɫ���øж�����
SSD_MAX_ROLE_CONTACT_COLUMN_NUM = 3     --������ɫ���øж�����
SSD_MAX_ROLE_CONTACT_ITEM_NUM = 9       --������ɫ���øж���(�����*�����)
SSD_BASE_ATTR_STR_LEN = 256             --��ɫ���������ַ�������
SSD_MAX_USER_ACCOUNT_TAG_JSON_STR_LEN = 256--��ɫ��¼��ǩJson�ַ�������
SSD_MAX_CHAR_KV = 1024                  --kv����
SSD_MAX_USER_PICTURE_URL_LEN = 256      --��ɫ΢�Ż�QQͷ�������ַ�������
SSD_MAX_ROLE_GIFT = 20                  --��������츳����
SSD_MAX_QUERY_FRIEND_INFO_NUM = 100     --������������Ϣ�ĺ�����
SSD_MAX_UPDATE_FRIEND_ATTR_KEY_LEN = 32 --�������Է����ж���ҵ����Ϣkey���
SSD_MAX_UPDATE_FRIEND_ATTR_VALUE_LEN = 1024--�������Է����ж���ҵ����Ϣvalue���
SSD_MAX_QUERY_FRIEND_SHAREDATA_KEY_LEN = 64--��ѯ��������
SSD_MAX_ADD_FRIEND_NUM = 200            --����Ӻ��ѵ��������
SSD_MAX_MERIDIANS_ACUPOINT_NUM = 80     --����Ѩλ�������
SSD_MAX_ROLE_EMBATTLE_MARTIAL_LEN = 64  --��ɫ������ѧ��¼��󳤶�
SSD_MAX_ROLE_EMBATTLE_MARTIAL_NUM = 50  --�ɳ�ս����ѧ�������
SSD_MAX_ROLE_COMBO_NUM = 5              --combo�������
SSD_MAX_MARTIAL_EXTARUNLOCK_CLAUSE_LEN = 64--ÿ����ѧ�����������ѧ��Ŀ��󳤶�
SSD_MAX_MARTIAL_EXTARUNLOCK_CLAUSE_NUM = 8--ÿ����ѧ�����������ѧ��Ŀ�������
SSD_MAX_INCOMPLETE_BOOK_UPLVL_NUM = 10  --ͨ�����¿������������ѧ�ȼ�����(��������Ϊ11-20)
SSD_MAX_MARTIAL_ATTR_NUM = 20           --ÿ����ѧ������������
SSD_MAX_MARTIAL_UNLOCKITEM_NUM = 20     --ÿ����ѧ���Ľ�����Ŀ����
SSD_MAX_MARTIAL_NUM = 64                --��ѧ�������
SSD_DEFAULT_MARTIAL_NUM = 10            --Ĭ����ѧ����
SSD_INCOMPLETEBOOK_RECORD_NUM = 100     --����ϻÿ���·����µ��������
SSD_AI_LIST_NUM = 15                    --AI������󳤶�
SSD_AI_CUSTOM_INDEX = 101               --�Զ���AI��������
SSD_SCRIPT_BITS = 32                    --�籾ID��ռλ��
SSD_MAX_SCRIPT_NUM = 10                 --�籾�����
SSD_MAX_SCRIPT_PLAT_NUM = 50            --�籾�����������Ʒ��
SSD_WEEKLYDEFAULT_LUCKYVALUE = 100      --ÿ�����õ�����ֵ
SSD_MAX_LUCKYVALUE = 990                --����������ֵ
SSD_ENTER_SCRIPT_CARRY_SPECIAL_DATA_NUM = 100--���籾ʱ�����������ݵĸ���
SSD_BUY_UNLOCK_NEXT_DIFF_SILVER_NUM = 1000--�籾�����Ѷ����ĵ���������
SSD_MAX_SEND_SCRIPT_PLAYER_ARRAY_NUMS = 100--�籾�ڷ���������Ϣ�����������
SSD_MAX_SILVER_UNLOCK_SCRIPT_DIFF = 10  --ͨ�������ɹ��������Ѷ�
SSD_MAX_STORY_WEEK_LIMIT_INFO_NUM = 20  --�籾��������Ϣ�������
SSD_MAX_SPECIAL_ITEM_UNLOCK_SCRIPT_DIFF = 21--ͨ���������߽���������Ѷ�
SSD_MAX_EVOLUTION_RECORD_NUM = 100      --�ݻ������ܼ�¼����
SSD_MAX_EVOLUTION_EACH_RECORD_LEN = 32  --�ݻ�ÿ����¼��󳤶�
SSD_MAX_EVOLUTION_DOWNLOAD_NUM = 200    --ÿ�����������ݻ�����
SSD_MAX_EVOLUTIONRECORD_NUM = 100       --���������ݻ���¼����
SSD_BATTLE_GRID_WIDTH = 8               --ս����ͼ���
SSD_BATTLE_GRID_HEIGHT = 5              --ս����ͼ�߶�
SSD_BATTLE_ROUND_TIME = 2               --ս���ִ�ʱ��
SSD_MAX_EMBATTLE_NUMS = 50              --�����������
SSD_MAX_INIT_EACH_EMBATTLE_NPC_NUMS = 5 --��ʼ������������
SSD_MAX_BATTLE_ROUND = 20               --ս�����غ���
SSD_MAX_BATTLE_LOG = 20                 --�������log����
SSD_MIN_POWER_THROUGH = 1000            --��������ʹ�͸����˥������Сֵ /10000
SSD_POWER_THROUGH_INIT = 2000           --��������ʹ�͸�����ݼ���ʼֵ /10000
SSD_BATTLE_INIT_MOVE = 3                --��ʼ�ƶ�����
SSD_MAX_BATTLE_END_AWARD_NUMS = 200     --�����㽱������
SSD_MAX_REBUILD_BATTLE_MAX_BUFF_LEN = 64--ս���ָ������е���buff�ַ�����󳤶�
SSD_MAX_REBUILD_BATTLE_MAX_TREASURE_BOX_LEN = 64--ս���ظ������б����ַ�����󳤶�
SSD_MAX_REBUILD_BATTLE_NEXT_ENEMY_GIFT_LEN = 76--ս���ָ������е����츳�ַ�����󳤶�
SSD_MAX_REBUILD_BATTLE_NEXT_FRIEND_GIFT_LEN = 76--ս���ָ��������ѷ��츳�ַ�����󳤶�
SSD_MAX_REBUILD_BATTLE_WHELL_ROUND_LEN = 28--ս���ָ������г���սս��ID�ַ�����󳤶�
SSD_MAX_REBUILD_BATTLE_PREUNIT_LEN = 32 --ս���ָ���������һ������λ�ַ�����󳤶�
SSD_MAX_REBUILD_BATTLE_EXTASK_MONITOR_LEN = 32--ս���ָ������ж�����������ַ�����󳤶�
SSD_MAX_REBUILD_BATTLE_ACC_MARTIAL_EXP_LEN = 256--ս���ָ������н�ɫ��ѧ�����ۻ��ַ�����󳤶�
SSD_MAX_YUANHU_LEN = 5                  --ս���ظ�������Ԯ���ַ�����󳤶�
SSD_MAX_UNIT_LEN = 64                   --ս���ظ������е�λ��󳤶�
SSD_MAX_TARGET_LEN_SELECT = 20          --ս�����������е�λ��󳤶�
SSD_MAX_TARGET_LEN = 30                 --ս���ظ������е�λ��󳤶�
SSD_MAX_BATTLEINFO_LEN = 1024           --ս���ظ������е�����Ϣ��󳤶�
SSD_MAX_ROLEEMBATTLE_LEN = 100          --ս���Ⲽ���Ա��Ϣ����
SSD_MAX_ASSIST_LEN = 10                 --��ս��Ա����
SSD_MAX_EQU_LEN = 10                    --��ս��Ա����
SSD_MAX_PLOT_LEN = 20                   --plot����
SSD_MAX_HEJI_LEN = 20                   --�ϻ�����
SSD_MAX_BUFF_LEN = 200                  --buff����
SSD_MAX_TREASURE_BOX_LEN = 20           --��������
SSD_MAX_TREASURE_BOX_AWARD_LEN = 20     --�����������
SSD_MAX_MAP_NPC_NUMS = 32               --������ͼ���������������
SSD_MAX_MAP_STR_LEN = 256               --������ͼռλID�洢��󳤶�
SSD_MAX_CITYEVENTS_NUMS = 16            --�����м��¼�����
SSD_MAX_CITYDATA_NUMS = 100             --������г�������
SSD_MAP_ADV_LOOT_BINARY_MAX_LEN = 1024  --��ͼ�������������ݳ������ֵ
SSD_MAP_MAP_FOREGROUND_MAX_LEN = 32     --��ͼǰ���������ֵ
SSD_MAP_MAP_REFCOUNT_MAX_LEN = 64       --��ͼ���ü����������ֵ
SSD_MAX_RANDOM_CITY_MOVE_NPC_COUNT = 8  --��ͼ����ƶ�NPC�������ֵ
SSD_MAX_SELECT_NUMS = 20                --ѡ���������
SSD_MAX_PLOT_NUMS = 128                 --���������������
SSD_MAX_SHOWFOREGROUND_NUMS = 16        --��ʾǰ���������
SSD_MAX_MAZE_BUFF_NUMS = 8              --�Թ�Buff�������
SSD_MAX_MAZE_BUFF_LEN = 8 * 8           --�Թ�Buff����ַ�����󳤶�
SSD_MAX_MAZE_AREA_NUMS = 8              --�Թ������������
SSD_MAX_MAZE_AREA_LEN = 8 * 5           --�Թ������ַ�����󳤶�
SSD_MAX_MAZE_GRID_NUMS = 8              --�Թ����������������
SSD_MAX_MAZE_GRID_LEN = 8 * 5           --�Թ����������ַ�����󳤶�
SSD_MAX_MAZE_AREA_GRID_NUMS = 400       --�Թ�������θ��������
SSD_MAX_MAZE_AREA_GRID_STATE_SIZE = ((SSD_MAX_MAZE_AREA_GRID_NUMS * 2) / 32)--�Թ�������θ�λ�����鳤��
SSD_MAX_MAZE_AREA_GRID_BITS_LEN = 276   --�Թ������λ���ַ�����󳤶�
SSD_MAX_MAZE_CARD_ADV_LOOT_NUMS = 32    --�Թ���Ƭ�����������
SSD_MAX_MAZE_CARD_DYNAMIC_ADV_LOOT_NUMS = 32--�Թ���Ƭ��̬�����������
SSD_MAX_DYNAMIC_ADV_LOOT_NUM = 200      --��̬�����������
SSD_MAX_MAZE_CARD_ADV_LOOT_LEN = 32 * 5 --�Թ���Ƭ������󳤶�
SSD_MAX_ADV_LOOT_BINARY_STR_LEN = 1024  --�Թ�������������ת���ַ�������󳤶�
SSD_MAX_UPDATE_MAZE_COUNT = 512         --���θ����Թ��������
SSD_MAX_UPDATE_MAZE_AREA_COUNT = 16     --���θ����Թ������������
SSD_MAX_UPDATE_MAZE_GRID_COUNT = 512    --���θ����Թ����������
SSD_MAX_UPDATE_MAZE_CARD_COUNT = 256    --���θ����Թ���Ƭ�������
SSD_MAX_OPR_PLAT_ITEM_NUM = 100         --һ���Բ���ƽ̨��Ʒ�ĵ��������
SSD_MAX_SELECT_SUBMIT_ITEM_NUM = 20     --һ�����ύ��Ʒ�ĵ��������
SSD_MAX_SHOP_ITEM_NUMS = 100            --�̵����������Ʒ����
SSD_MAX_ADVLOOT_ITEM_NUMS = 1000        --���ð�յ�����������
SSD_MAX_PLAT_ITEM_CHOOSEGIFT_NUM = 5    --ƽ̨��Ʒ���ѡ���������
SSD_ITEM_USE_LEVEL_UP_LIMIT = 4         --��Ʒʹ�õ�??l��?_ʼ������??����?��ֵ
SSD_ITEM_PROTECT_ENHANCE_GRADE = 5      --��Ʒ�ʲ�������ǿ���ȼ�
SSD_MAX_HOODLE_LOTTERY_SLOTINFO_LEN = 64--������е������Ϣ��󳤶�
SSD_MAX_HOODLE_PROGRESS_BOXINFO_LEN = 64--������н��Ȳ���Ϣ��󳤶�
SSD_MAX_HOODLE_SLOT_NUM = 7             --������������
SSD_MAX_HOODLE_PROGRESS_BOX_NUM = 4     --���Ȳ��������
SSD_HOODLE_SILVER_EXCHANGE_NUM = 248    --�һ�С��������������
SSD_HOODLE_SILVER_EXCHANGE_TO_MERIDIANS_NUM = 10--�����һ�С�������͵ľ�������
SSD_MAX_DAILY_FREE_LITTLE_WARRIOR_NUM = 3--ÿ���������С��������
SSD_MIN_OPEN_TEN_SHOOT_HOODLE_NUM = 300 --��������ʮ�Ź�����Ҫ�ۼƵ�ʹ��С���������Ч����
SSD_ONCE_REPEAT_HOODLE_BALL_NUM = 10    --ʮ��(���)��������
SSD_MAX_CHILD_MARTIAL_LEN = 128         --���ӿɴ�������ѧ��󳤶�
SSD_MAX_CHILD_GIFT_LEN = 128            --���ӿɴ������츳��󳤶�
SSD_MAX_CHILD_ATTR_LEN = 128            --���ӿɴ����Ļ���������󳤶�
SSD_MAX_CHILD_TASK_LEN = 128            --���ӿɴ�����������󳤶�
SSD_MAX_TAKEOUT_BABY_NUM = 10           --�ɴ������ǵĺ����������
SSD_MAX_TAKEOUT_BABYS_LEN = 128         --�ɴ������ǵĺ�����󳤶�
SSD_MAX_ACHIEVE_NUMS = 100              --ƽ̨�ɾ͵ĵ��������
SSD_MAX_CARRY_ACHIEVE_REWARD_NUMS = 50  --���ִ���ɾ���Ŀ���������
SSD_MAX_ACHIEVE_BINARY_STR_LEN = 4096   --ƽ̨�ɾͶ����ƴ洢���ֵ
SSD_MAX_ACHIEVE_RECORD_MAX_NUM = 100    --����ɾͼ�¼�����������
SSD_MAX_ACHIEVE_SEND_MAX_NUM = 100      --�ɾͷ����������
SSD_MAX_DIFFDROP_SEND_MAX_NUM = 100     --ȫ���Ѷȵ�����Ʒ����������
SSD_MAX_CLAN_NUMS = 100                 --�����������
SSD_MAX_CLAN_ELIMINATED_LEN = 64        --��������ͳ���ַ���
SSD_MAX_BUILDING_NAME_LEN = 32          --���ɽ�������󳤶�����
SSD_MAX_MATERIAL_CLASS = 16             --���ɽ���������������
SSD_MAX_DISCIPLENUM_PER_BUILDING = 2    --ÿ������������ɵ�����
SSD_MAX_BUILDING_NUM_PER_FLOOR = 4      --ÿ����ཨ������
SSD_MAX_CITY_EVENT_NUMS = 4             --�����¼��������
SSD_MAX_CITY_EVENT_LEN = 16 * 10        --�����¼���󳤶�
SSD_MAX_CITY_TIMER_COUNT = 16           --���м�ʱ���������
SSD_MAX_CITY_TIMER_LEN = 16 * 10        --���м�ʱ����󳤶�
SSD_MAX_CITY_TASK_NUMS = 12             --���������������
SSD_MAX_SEND_UNLOCK_NUMS = 100          --ĳ�����һ�����·�������Ϣ�������
SSD_MAX_ONCE_TALK_STR_LEN = 720         --���һ���������ݵ���󳤶�
SSD_MAX_PUBLIC_CHANNEL_CHAT_COST_GOLD_NUM = 1--Ƶ���������ĵ�Ԫ����
SSD_MAX_PUBLIC_CHANNEL_CHAT_COST_SILVER_NUM = 1--Ƶ���������ĵ�������
SSD_MAX_PUBLIC_CHANNEL_CHAT_EACH_TALK_SEC = 3--Ƶ������ÿ�μ������
SSD_MAX_PUBLIC_CHANNEL_CHAT_ONE_MINUTES_MAX_NUM = 10--Ƶ������һ������ི������
SSD_MAX_PUBLIC_CHANNEL_CHAT_TEN_MINUTES_MAX_NUM = 30--Ƶ������ʮ������ི������
SSD_MAX_PRIVATE_SESSION_ID_LEN = 128    --˽�ĵ�SessionID
SSD_MAX_WORLD_FREE_TALK_MERIDIANS_LVL = 0--�������������Ҫ�ľ����ȼ�
SSD_MAX_TASK_PARAM_LEN = 256            --����洢��󳤶�
SSD_MAX_TASK_DESC_NUMS = 20             --�������������������ֵ
SSD_MAX_TASK_NOT_REPEATED_EDGE_NUMS = 64--�������񲻿��ظ����������ֵ
SSD_MAX_TASK_EDGE_NUMS = 256            --����������������ֵ
SSD_MAX_CUSTOM_PARAMS_NUMS = 20         --�Զ����������
SSD_MAX_TASK_DYNAMIC_DATA_NUMS = 48     --��̬���ݸ������ֵ
SSD_MAX_TASK_CUSTOM_KEY_DYNAMIC_DATA_NUMS = 96--�Զ�����Ķ�̬���ݸ������ֵ
SSD_MAX_TASK_NORMAL_REWARD_NUMS = 8     --����̬ͨ�ý����������
SSD_MAX_TASK_NORMAL_REWARD_STR_LEN = 100--����̬ͨ�ý������л��ַ�����󳤶�
SSD_MAX_TASK_REWARD_NUMS = 8            --����̬�����������
SSD_MAX_TASK_DISPO_REWARD_FINAL_DELTA_NUMS = 8--����ʵ�ʺøжȱ仯�������
SSD_MAX_TASK_REWARD_STR_LEN = 100       --����̬�������л��ַ�����󳤶�
SSD_MAX_TASK_ROLE_DISPOSITION_REWARD_LENS = 44--��ɫ�øн����б�洢�ַ�����
SSD_MAX_TASK_CLAN_DISPOSITION_REWARD_LENS = 44--���ɺøн����б�洢�ַ�����
SSD_MAX_TASK_CITY_DISPOSITION_REWARD_LENS = 44--���кøн����б�洢�ַ�����
SSD_MAX_RANKID_LEN = 32                 --���а�ID��󳤶�
SSD_MAX_RANK_SCORE_LEN = 64             --���а������󳤶�
SSD_MAX_SNAP_LEN = 8                    --���а������󳤶�
SSD_MAX_UPDATE_NUMS = 20                --���а�����������
SSD_MAX_MEMBER_LEN = 128                --member��󳤶�
SSD_MAX_RANK_NUMS = 30                  --���а������Ŀ��
SSD_MAX_TITLE_RANK_NUMS = 150           --�ƺŰ������Ŀ��
SSD_ROLE_DISPOSITION_100 = 100
SSD_ROLE_DISPOSITION_RATE = 2000        --��ɫ�ø�˥��ϵ��
SSD_ROLE_DISPOSITION_NUM = 5000         --��ɫ�ø�˥��ϵ��
SSD_ROLE_DISPOSITION_DEFAULT = 10       --Ĭ��npc�����Ǻøж�
SSD_ROLE_DISPOSITION_LOW_STATE_1 = -1   --�ͺøж�-1
SSD_ROLE_DISPOSITION_LOW_STATE_51 = -51 --�ͺøж�-51
SSD_ROLE_DISPOSITION_LOW_STATE_100 = -100--�ͺøж�-100
SSD_MAX_RANDOM_EVOLUTION_ROLE = 250     --��������ݻ���������
SSD_EVOLUTION_CHAIN_LIMIT_NUM = 15      --���˹�ϵ���ݻ�
SSD_MAX_EVOLUTIONRECORD_SAVE_NUM = 500  --����ݻ���¼��������
SSD_MAX_TREASUREMAZE_MAILRECV_SEC = 60 * 60--���ط�������ʼ���ȡʱ������1��Сʱ
SSD_MAX_TREASUREMAZE_SHARE_FRIENDNUMS = 100--���ط�������������
SSD_MAX_ARENA_MATCH_NUMS = 20           --�����������
SSD_MAX_ARENA_BATTLE_NUMS = 32          --ս���������
SSD_MAX_ARENA_SIGNUP_MEMBER_NUMS = 32   --��Χ����������
SSD_MAX_ARENA_BET_RANK_NUMS = 100       --���������������
SSD_MAX_ARENA_TEAM_DATA_MAX_SIZE = 3072 --�����������ֵ
SSD_MAX_ARENA_PK_DATA_MAX_SIZE = 40960  --PK�������ֵ
SSD_MAX_ARENA_PK_DATA_MAX_COUNT = 2     --PK�����������ֵ
SSD_MAX_ARENA_RECORD_DATA_MAX_SIZE = 65536--¼���������ֵ
SSD_MAX_ARENA_RECORD_DATA_ALL_MAX_SIZE = 1048576--¼���������ֵ
SSD_MAX_ARENA_ROLE_SIZE = 5             --��̨����������ɫ����
SSD_MAX_REQUEST_ARENA_CMD_SIZE = 64     --�ͻ���������̨�����������
SSD_MAX_FINALBATTLE_TEAM_NUMS = 16      --���ս�����������
SSD_MAX_REST_TEAMMATES_NUMS = 32        --����Ϣ�����������
SSD_MAX_REST_TEAMMATES_LEN = 352        --����Ϣ������󳤶�
SSD_MAX_FINALBATTLE_ALIVEFRIEND_LEN = 36--���ս���д�����ID�ַ�����
SSD_MAX_FINALBATTLE_DEADFRIEND_LEN = 36 --���ս������������ID�ַ�����
SSD_MAX_FINALBATTLE_ALIVEENEMY_LEN = 36 --���ս���д��з�ID�ַ�����
SSD_MAX_FINALBATTLE_DEADENEMY_LEN = 36  --���ս���������з�ID�ַ�����
SSD_MAX_HIGHTOWER_REST_TEAMMATES_NUMS = 60--ǧ��������Ϣ�����������
SSD_MAX_QUERYRACK_ITEM_NUMS = 32        --ÿ�β�ѯ�̳���Ʒ�������
SSD_MAX_ADD_PLAT_ITEM_NUM = 10          --һ���Բ��������Ʒ�ĵ��������
SSD_MAX_BUY_PLAT_ITEM_NUM = 10          --ÿ�ι�����������
SSD_MAX_PLAT_ITEM_USEMAX_NUM = 99       --����ƽ̨ʹ����Ʒ�������
SSD_MAX_PLATTEAM_MAX_SIZE = 20*1024     --ƽ̨�����������ֵ
SSD_MAX_INSTROLE_MAX_SIZE = 30*1024     --ƽ̨����ʵ����ɫ�������ֵ
SSD_MAX_COMMON_MAX_SIZE = 1024          --ƽ̨����ͨ���������ֵ
SSD_MAX_EMBATTLE_MAX_SIZE = 1024        --ƽ̨�����������ֵ
SSD_MAX_QUERYRACK_RACK_NUMS = 10        --ÿ�β�ѯ�̳ǻ����������
SSD_MAX_RANK_MEMBER_MAX_SIZE = 128      --���а�member��󳤶�
SSD_CHALLENGEORDER_MID_LOGIN_DAYS = 30  --������м���ս���¼����
SSD_CHALLENGEORDER_MID_PRICE = 18       --�м���ս��۸�
SSD_CHALLENGEORDER_HIGH_PRICE = 68      --�߼���ս��۸�
SSD_MAX_INQUIRY_GOODEVIL_PLUS = 30      --����ֵ����30�����̲�
SSD_MAX_INQUIRY_GOODEVIL_MINUS = -30    --����ֵ����-30�����̲�
SSD_DOUBT_PERVERSITY_GIFTID = 1781      --�̲����츳���ɵ�����id
SSD_DOUBT_BLOOD_GIFTID = 1782           --�̲����츳���ɵ�Ѫ��id
SSD_DOUBT_MARTIAL_GIFTID = 1783         --�̲����츳���ɵ�����id
SSD_DOUBT_BAG_GIFTID = 1784             --�̲����츳���ɵİ���id
SSD_ZHUWEITIPSNEEDMONEY = 10000         --����ȫ����ʾ���
SSD_COLLECTIONPOINT_MAX_SIZE = 20       --�ղص�����󳤶�
SSD_MAX_MATCH2ROLEVEC_SIZE = 256        --������ɫ��ϴ���󳤶�
SSD_MAX_MATCH2RANDROLEVEC_SIZE = 256    --�����ɫ��ϴ���󳤶�
SSD_MAX_MATCH2STATE_SIZE = 256          --����״̬��ϴ���󳤶�
SSD_CREDIT_SCORE_QUERY_TIMEOUT = 5      --���÷ֽӿ�����ʱʱ�� 5��
SSD_CREDIT_SCORE_EXPIRES_TIME = 4*3600  --���÷ֹ���ʱ��
SSD_CREDIT_SCORE_SCENE_LIMIT_EXPIRES_TIME = 5*60--�������ƹ���ʱ��
SSD_LIMIT_SHOP_MAX_YAZHU_INFO_LEN = 2048--Ѻע��Ϣ��󳤶�
SSD_PALT_CHALLENGE_REWARD_ITEM_MAX = 5  --ƽ̨�д���Ʒ����ÿ��������
SSD_PALT_CHALLENGE_REWARD_GIFTPACK_MAX = 2--ƽ̨�д��������ÿ��������
SSD_MAX_ZM_BATTLE_CARD_SIZE = 7         --�������������
SSD_MAX_ZM_SELECT_CARD_SIZE = 4         --���ѡ��������
SSD_MAX_ZM_SELECT_CLAN_SIZE = 3         --���ѡ����������
SSD_MAX_ZM_SELECT_EQUIP_SIZE = 4        --���ѡ��װ������
SSD_MAX_ZM_CARD_POOL_SIZE = 32          --��������
SSD_MAX_ZM_CARD_SIZE = 120              --���������
SSD_MAX_ZM_EQUIP_SIZE = 32              --���װ������
SSD_MAX_ZM_BATTLE_NUMS = 64             --ս���������
SSD_MAX_ZM_PLAYER_NUMS = 32             --����������
SSD_MAX_ZM_NOTICE_PAIRS_NUMS = 32       --���֪ͨ����
SSD_MAX_ZM_FREEZE_CARD_SIZE = 16        --���������
SSD_MAX_ZM_ROLE_CARD = 400              --���ƽ̨��Ƭ
SSD_GRAB_TITLE_MAX_PLAYER_NUM = 50      --ǰ100���
SSD_MAX_RESDROP_ACTIVITY_NUM = 100      --��������
SSD_MAX_COLLECT_ACTIVITY_TASK_NUM = 20  --����ռ�������
SSD_MAX_COLLECT_ACTIVITY_EXCHANGE_BASE_ID = 150001--�ռ���һ�������ǿ�ʼ��id, ��TaskTag���ж��廮�ַ�Χ
SSD_OPENTREASURE_GIVEFRIENDDROPID = 10029--�����ر�ͼ���ѻ�ȡ��������id
SSD_MAX_KVSTORE_KEY_LEN = 1024          --key��󳤶�
SSD_MAX_KVSTORE_VALUE_LEN = 4096        --value��󳤶�
SSD_DEFAULT_LANDLADY_ID = 10090001      --Ĭ���ϰ���id
SSD_MAX_PLAT_ITEM_TO_SCRIPT_NUMS = 99*99--�ֿ����籾��Ʒ���������������
SSD_MAX_GUIDE_FLAG_ARRAY_SIZE = 10      --������Ϣ������鳤��
SSD_MAX_DAILYDELSCRIPT_NUMS = 5         --�籾ÿ�����ɾ����������
SSD_DEFAULT_TEAPOT_ID = 10110001        --Ĭ�ϰڼ�id
SSD_MAX_UNKNOWNSIZE_512 = 512           --δ֪��С512
SSD_MAX_UNKNOWNSIZE_1024 = 1024         --δ֪��С1024
SSD_MAX_UNKNOWNSIZE_65536 = 65536       --δ֪��С65536
SSD_MAX_ROLEFACE_LEN = 256              --���������ַ������泤��
SSD_MAX_MAINROLE_NICKNAME = 8400        --�����ǳ����ݴ��泤��
--to C++ enum [SeShareDef] Define END

--to C++ enum [SeChangeType] Define BEGIN
SCT_NULL = 0
SCT_UPDATE = 1
SCT_INSERT = 2
SCT_DELETE = 3
SCT_NUM = 4
--to C++ enum [SeChangeType] Define END

--to C++ enum [SeConnectState] Define BEGIN
SCS_UNKOWN = 0                          --δ֪״̬
SCS_VALID_FAILED = 1                    --ʧ��
SCS_VALID_OK = 100                      --�ɹ�
--to C++ enum [SeConnectState] Define END

--to C++ enum [SeRedPacketType] Define BEGIN
SRPT_NULL = 0
SRPT_MONEY = 1
SRPT_ITEM = 2
--to C++ enum [SeRedPacketType] Define END

--to C++ enum [SeOpenTreasureType] Define BEGIN
SOTT_NULL = 0
SOTT_SELF = 1
SOTT_FRIEND = 2
--to C++ enum [SeOpenTreasureType] Define END

--to C++ enum [SeBroadChatType] Define BEGIN
SBCT_NULL = 0
SBCT_PAOMA = 1                          --����
SBCT_DANMU = 2                          --��Ļ
SBCT_DENGLUCI = 3                       --��¼��
SBCT_DANMUJILU = 4                      --��Ļ�������
SBCT_CLEARONEPLAYERCHAT = 5             --�������
SBCT_SendRedTip = 6                     --�����ʾ
SBCT_SysTips = 7                        --ϵͳ�����
SBCT_PINBALLREWARD = 8                  --�����л�
--to C++ enum [SeBroadChatType] Define END

--to C++ enum [SeChangeBaseOptType] Define BEGIN
SCBOT_NULL = 0
SCBOT_GOLD = 1
SCBOT_SILVER = 2
SCBOT_JINGMAIEXP = 3
--to C++ enum [SeChangeBaseOptType] Define END

--to C++ enum [SeDBRelatedSwitch] Define BEGIN
SDBRS_NONE = -1
SDBRS_SHOP_BUY = 1
SDBRS_EXCHANGE = 2
SDBRS_TASK = 3
SDBRS_ACTIVITY = 4
SDBRS_CORP = 5
SDBRS_AUCTION = 6
SDBRS_BUGLE = 7
SDBRS_TALK = 8
SDBRS_SIGN = 9
SDBRS_COMPOSE = 10
SDBRS_SPLIT = 11
SDBRS_STRENGTHEN = 12
SDBRS_ACHELPER = 13
SDBRS_AUCTION_NORMAL = 14
SDBRS_COMMON = 15                       --ͨ�ù��ܹر�(Ӧ�Է������ر�ĳ����ȴû��ö����)
SDBRS_TOTAL = 16
--to C++ enum [SeDBRelatedSwitch] Define END

--to C++ enum [SeGameLogicSwitchType] Define BEGIN
SGLST_NONE = 0
SGLST_TREASUREBOOK = 1                  --�ٱ������幦��
SGLST_HOODLELOTTERY = 2                 --����
SGLST_PLAT_SHOP = 3                     --ƽ̨�̳ǹ���
SGLST_SMELT_SPECIAL = 4                 --�����������ѵľ�����������
SGLST_RELATION_BOND = 5                 --�ϵͳ
SGLST_GIVEFRIEND_TREASUREBOOK = 6       --���ͺ��Ѱٱ���
SGLST_TOTAL = 7
--to C++ enum [SeGameLogicSwitchType] Define END

--to C++ enum [SeGameLogicHotUpdateType] Define BEGIN
SGLUT_NONE = 0
SGLUT_SETUP = 1                         --����
SGLUT_KICKCACHE = 2                     --�����建��
SGLUT_RESET_ONLINE = 3                  --(DB崻�����ʱ)��������״̬
SGLUT_FINIALIZE = 4                     --�߳�Finialize
SGLUT_RELOAD_TABLE = 5                  --���¼������ݱ�
SGLUT_TOTAL = 6
--to C++ enum [SeGameLogicHotUpdateType] Define END

--to C++ enum [SeTencentAntiAddictionHeartBeatType] Define BEGIN
STAAHBT_NONE = 0
STAAHBT_BEGIN = 11                      --��ʼ
STAAHBT_KEEP = 12                       --����
STAAHBT_STOP = 13                       --����
--to C++ enum [SeTencentAntiAddictionHeartBeatType] Define END

--to C++ enum [SeTencentReportCheatType] Define BEGIN
STRCT_CURSE = 1                         --��������
STRCT_ADVERTISING = 2                   --�������
STRCT_ILLEGAL_NAME = 4                  --�����ǳ�
STRCT_CHEAT = 8                         --ʹ�����
STRCT_ILLEGAL_WORK = 16                 --��������Ϊ
STRCT_OTHER = 32                        --����
--to C++ enum [SeTencentReportCheatType] Define END

--to C++ enum [SeTencentAntiAddictionInstructionType] Define BEGIN
STAAIT_NONE = 0
STAAIT_TIPS = 1                         --����ʾ
STAAIT_LOGOUT = 2                       --ǿ������
STAAIT_OPENURL = 3                      --����ҳ
STAAIT_USER_DEFINED = 4                 --�û��Զ���
STAAIT_INCOME = 5                       --���棬������
STAAIT_INCOME_TIPS = 6                  --�����ҵ���
STAAIT_STOP = 7                         --ֹͣ����
--to C++ enum [SeTencentAntiAddictionInstructionType] Define END

--to C++ enum [SeTLogNPCActType] Define BEGIN
STLNAT_NONE = 0
STLNAT_WATCH = 1                        --�۲�
STLNAT_INVITATION = 2                   --����
STLNAT_GIVEGIFT = 3                     --����
STLNAT_COMPARE_BATTLE = 4               --�д�ս��
STLNAT_COMPARE_GET_ITEM = 5             --�д�����Ʒ
STLNAT_COMPARE_GET_TITLE = 6            --�д��óƺ�
STLNAT_DUEL = 7                         --����
STLNAT_SWORN = 8                        --����
STLNAT_MARRIED = 9                      --��Լ
STLNAT_CONSULT = 10                     --���
STLNAT_STEAL = 11                       --͵ѧ
STLNAT_TEAMMATE = 12                    --���
STLNAT_LEAVE = 13                       --���
STLNAT_BEG = 14                         --����
STLNAT_PUNISH = 15                      --�Ͷ�
STLNAT_CALLUP = 16                      --����
STLNAT_INQUIRY = 17                     --�̲�
STLNAT_EXILE = 18                       --����
STLNAT_DUELALL = 19                     --����
STLNAT_ALLY = 20                        --����
STLNAT_ABSORB = 21                      --����
--to C++ enum [SeTLogNPCActType] Define END

--to C++ enum [SeTLogShareOtherType] Define BEGIN
STLSOT_NONE = 0
STLSOT_INVITATION = 1                   --�������
STLSOT_APPRENTICE_ATTR = 2              --ͽ������
STLSOT_JOIN_CLAN = 3                    --���ɼ���
STLSOT_SCRIPT_END = 4                   --ͨ�ؽ��
STLSOT_CHALLENGE_SUC = 5                --�д��ʤ
STLSOT_SCREENSHOTS = 6                  --�ֶ�����
--to C++ enum [SeTLogShareOtherType] Define END

--to C++ enum [SeTLogShareToType] Define BEGIN
STLSTT_NONE = 0
STLSTT_QQ = 1                           --QQ
STLSTT_WX = 2                           --WX
STLSTT_QQ_ZONE = 3                      --QQ�ռ�
STLSTT_WX_PYQ = 4                       --WX����Ȧ
--to C++ enum [SeTLogShareToType] Define END

--to C++ enum [SeTLogEnterScriptStageType] Define BEGIN
STESST_NONE = 0
STESST_FINISH_FAQ = 1                   --��ɽ����ʴ�
STESST_CREATE_ROLE = 2                  --���������ɫ
STESST_CLICK_START = 3                  --��ʼ��Ϸ
STESST_ENTER_SCRIPT = 4                 --������Ϸ
--to C++ enum [SeTLogEnterScriptStageType] Define END

--to C++ enum [SeTLogEquipBackUpTimingType] Define BEGIN
STEBUTT_NONE = 0
STEBUTT_RECYLE = 1                      --����
STEBUTT_ENTER_SCRIPT = 2                --����籾
STEBUTT_END_SCRIPT = 3                  --�����籾
STEBUTT_SELL = 4                        --�̳�����
STEBUTT_DECOMPOSE = 5                   --�ֽ�
STEBUTT_GET = 6                         --���
STEBUTT_GIVE = 7                        --����
STEBUTT_COMPENSATION = 8                --(�ʼ�)����
STEBUTT_REMAKE = 9                      --����
STEBUTT_ENHANCE = 10                    --ǿ��
--to C++ enum [SeTLogEquipBackUpTimingType] Define END

--to C++ enum [SeTLogUserDefineActivityIDType] Define BEGIN
STUDAIT_NONE = 0
STUDAIT_3DAY = 1000001                  --����ǩ��
STUDAIT_7DAY = 1000002                  --����ǩ��
STUDAIT_WAITERREWARD = 1000003          --�ϰ���ÿ��������ȡ
STUDAIT_COLLECTION = 1000004            --���ֻ
STUDAIT_TREASURE = 1000005              --��������
--to C++ enum [SeTLogUserDefineActivityIDType] Define END

--to C++ enum [SeTencentPrivateInfo] Define BEGIN
STPT_QQ = 0
STPT_WECHAT = 1
--to C++ enum [SeTencentPrivateInfo] Define END

--to C++ enum [BillNoState] Define BEGIN
BNST_NULL = 0                           --��Ч
BNST_NEW = 1                            --����
BNST_MFAIL = 2                          --�����״�ʦ��ʧ��
BNST_MSUCESS = 3                        --�����״�ʦ��ɹ�
BNST_GFAIL = 4                          --������Ϸ��fail
BNST_RFAIL = 5                          --�״�ʦ�ع�ʧ��
BNST_GDONE = 6                          --������Ϸ��success
--to C++ enum [BillNoState] Define END

--to C++ enum [SeTLogNameType] Define BEGIN
STLNT_Null = 0
STLNT_GameSvrState = 1
STLNT_PlayerRegister = 2
STLNT_PlayerLogin = 3
STLNT_PlayerLogout = 4
STLNT_MoneyFlow = 5
STLNT_ItemFlow = 6
STLNT_PlayerExpFlow = 7
STLNT_SnsFlow = 8
STLNT_RoundFlow = 9
STLNT_GuideFlow = 10
STLNT_VipLevelFlow = 11
STLNT_ActivityFlow = 12
STLNT_TaskFlow = 13
STLNT_LotteryFlow = 14
STLNT_GuildFlow = 15
STLNT_PlayerCoreAttributesFlow = 16
STLNT_PlayerEquipmentReMakeFlow = 17
STLNT_PlayerCanZhangFlow = 18
STLNT_PlayerCanWenFlow = 19
STLNT_PlayerActNPCFlow = 20
STLNT_PlayerIntoSceneFlow = 21
STLNT_PlayerMazeFlow = 22
STLNT_PlayerUnlock = 23
STLNT_PlayerTreasureBook = 24
STLNT_PlayerActPlayerFlow = 25
STLNT_PlayerPetFlow = 26
STLNT_PlayerTalkFlow = 27
STLNT_PlayerPlatShop = 28
STLNT_ScriptClanFlow = 29
STLNT_InCompleteFlow = 30
STLNT_Achievement = 31
STLNT_ScriptRegister = 32
STLNT_ScriptCompleted = 33
STLNT_CardDevelop = 34
STLNT_EquipBackUp = 35
STLNT_SceneShare = 36
STLNT_WatchADSFlow = 37
STLNT_PropertyFlow = 38
STLNT_EquipRemake = 39
STLNT_PvPFlow = 40
STLNT_LimitShopFlow = 41
STLNT_PlayerEnterCityFlow = 42
STLNT_MakeMartialSecretFlow = 43
STLNT_RoleFace = 44
STLNT_End = 45
--to C++ enum [SeTLogNameType] Define END

--to C++ enum [SePlayerCommonInfoRetType] Define BEGIN
FLAT_COMMONINFO_NULL = 0                --��Ч
FLAT_COMMONINFO_MERIDIANS_EXP = 1       --������ǰ�ܾ���
FLAT_COMMONINFO_WEEK_MERIDIANS_EXP = 2  --�����ܻ�þ���
FLAT_COMMONINFO_WEEK_MERIDIANS_OPENLIMIT = 3--�����ܿ����޴���
FLAT_COMMONINFO_RENAME_TIMES = 4        --��������
FLAT_COMMONINFO_BRMB = 5                --��ͨ����
FLAT_COMMONINFO_LUCKEYVALUE = 6         --����ֵ
FLAT_COMMONINFO_ADVANCEPURCHASE = 7     --ԤԼ�쿨
FLAT_COMMONINFO_MERIDIANS_BREAK_ITEM_NUM = 8--������ǰʣ����鵤����
FLAT_COMMONINFO_WEEK_RECYCLE_LVL = 9    --�����ܻ��յȼ�
FLAT_COMMONINFO_SAVEDB_DIRTY_STATE = 10 --������״̬
--to C++ enum [SePlayerCommonInfoRetType] Define END

--to C++ enum [SeForBidType] Define BEGIN
SFBT_NULL = 0                           --��Ч
SEOT_FORBIDALLCHAT = 1                  --ȫ��ȫ������
SEOT_FORBIDCHAT = 2                     --ȫ������
SEOT_SILENTCHAT = 3                     --ȫ����Ĭ
SEOT_FORBIDEDITTEXT = 4                 --��ֹ�޸��ı�
SEOT_FORBIDADDFRIEND = 5                --��ֹ�Ӻ���
SEOT_FORBIDRANK = 6                     --��ֹ���а�
--to C++ enum [SeForBidType] Define END

--to C++ enum [SeScriptOprType] Define BEGIN
SEOT_NULL = 0                           --��Ч
SEOT_ENTER = 1                          --����籾
SEOT_QUIT = 2                           --�˳��籾
SEOT_DEL = 3                            --ɾ���籾
SEOT_QUERY = 4                          --�籾��Ϣ����
SEOT_BUYDIFF = 5                        --�����Ѷ�
SEOT_FORCEEND = 6                       --ǿ�ƽ����籾��Ŀ
SEOT_QUITGAME = 7                       --�˳���Ϸ
--to C++ enum [SeScriptOprType] Define END

--to C++ enum [SePlatItemOprType] Define BEGIN
SPIO_NULL = 0                           --��Ч
SPIO_QUERY = 1                          --��ѯ
SPIO_INTO_SCRIPT = 2                    --����籾
SPIO_OUT_SCRIPT = 3                     --�����籾
SPIO_DEL = 4                            --ɾ����Ʒ
SPIO_RECYCLE = 5                        --������Ʒ
SPIO_USEITEM = 6                        --ʹ����Ʒ
--to C++ enum [SePlatItemOprType] Define END

--to C++ enum [SeScriptLuckyType] Define BEGIN
SSLT_NOLUCKY = 0                        --������ֵ
SSLT_NEWPLAYER = 1                      --�����Ĭ������ֵ
SSLT_NORMAL = 2                         --������������ֵ
--to C++ enum [SeScriptLuckyType] Define END

--to C++ enum [SeAchievementNoticeType] Define BEGIN
SANT_NULL = 0                           --��Ч
SANT_REFRESH = 1                        --��ѯ��ˢ��
SANT_ADD = 2                            --��������
--to C++ enum [SeAchievementNoticeType] Define END

--to C++ enum [SeMeridiansOprType] Define BEGIN
SMOT_NULL = 0                           --��Ч
SMOT_REFRESH_ALL = 1                    --ˢ��ȫ������
SMOT_REFRESH_ONE = 2                    --ˢ�µ�Ѩ����
SMOT_LEVEL_UP = 3                       --Ѩλ����
SMOT_BUY_LIMITNUM = 4                   --��������
SMOT_BREAK_LIMIT = 5                    --����ͻ��
--to C++ enum [SeMeridiansOprType] Define END

--to C++ enum [SeMailOprType] Define BEGIN
SMAOT_NULL = 0                          --��Ч
SMAOT_SEND = 1                          --�����ʼ�
SMAOT_SYSTEM_SEND = 2                   --�����ʼ�
SMAOT_GET = 3                           --��ȡ�ʼ�����
SMAOT_DEL = 4                           --ɾ���ʼ�
--to C++ enum [SeMailOprType] Define END

--to C++ enum [SeFriendBroadcast] Define BEGIN
SFBC_NULL = 0                           --��Ч
SFBC_OPENTREASURE = 1                   --�����ѷ��Ϳ�������ͼ��Ϣ
--to C++ enum [SeFriendBroadcast] Define END

--to C++ enum [SeClanCollectionQueryType] Define BEGIN
SCCQT_NULL = 0                          --��Ч
SCCQT_HEAT = 1                          --�����ȶ�
--to C++ enum [SeClanCollectionQueryType] Define END

--to C++ enum [SeAdvancePurchaseType] Define BEGIN
SAPT_NULL = 0                           --��Ч
SAPT_BY_OTHER = 1                       --�ɱ�������
SAPT_GIVE = 2                           --���ͱ���
SAPT_GIVE_FAIL = 3                      --���ͱ���ʧ��
SAPT_GIVE_SUC_1 = 4                     --���ͱ��˱��°ٱ���ɹ�
SAPT_GIVE_SUC_2 = 5                     --���ͱ��˴��°ٱ���ɹ�
SAPT_QUERY_ONLINE = 6                   --��ѯ����
--to C++ enum [SeAdvancePurchaseType] Define END

--to C++ enum [SeTreasureBookEnableType] Define BEGIN
STBET_NULL = 0                          --��Ч
STBET_SELF = 1                          --�Լ�����
STBET_BY_OTHER = 2                      --��������
STBET_System = 3                        --ϵͳ����
STBET_GIVE = 4                          --��������
--to C++ enum [SeTreasureBookEnableType] Define END

--to C++ enum [SeTreasureBookTaskType] Define BEGIN
STBTT_NULL = 0                          --��Ч
STBTT_NORMAL = 1                        --��������
STBTT_ACTIVITY = 2                      --�����
STBTT_ACTIVITY_BACKFLOW = 3             --�����-����
STBTT_ACTIVITY_FESTIVAL_DIALY = 4       --�����-���ջ�ճ�����
--to C++ enum [SeTreasureBookTaskType] Define END

--to C++ enum [SeTreasureBookQueryType] Define BEGIN
STBQT_NULL = 0                          --��Ч
STBQT_BRMB = 1                          --��ͨ����
STBQT_BASE = 2                          --������Ϣ
STBQT_TASK = 3                          --������Ϣ
STBQT_MALL = 4                          --�̳���Ϣ
STBQT_EXCHANGE = 5                      --�һ���Ʒ
STBQT_FREE_REWARD = 6                   --��ȡÿ��/�ܽ���
STBQT_LVL_REWARD = 7                    --��ȡ�ȼ�����
STBQT_RECHARGE_PROGRESS = 8             --����ȫ����ֵ����
STBQT_PROGRESS_REWARD = 9               --��ȡȫ����ֵ���Ƚ���
STBQT_ADVANCE_PURCHASE = 10             --��ĩԤ��
STBQT_BUY_EXP = 11                      --����ٱ��龭��
STBQT_LVL_CAN_REWARD = 12               --��ȡ����ĵȼ�����
STBQT_CLICK_REQUEST = 13                --���ˢ��
STBQT_NUM = 14
--to C++ enum [SeTreasureBookQueryType] Define END

--to C++ enum [SeHoodleLotteryPoolType] Define BEGIN
SHLPLT_NULL = 0                         --��Ч
SHLPLT_NORMAL = 1                       --��ͨ����Ϣ
SHLPLT_HOLIDAY = 2                      --���ճ���Ϣ
SHLPLT_ROTATION = 3                     --�ֻ�����Ϣ
SHLPLT_WELFARE1 = 4                     --���ָ�����1��Ϣ,����ʾ���
SHLPLT_WELFARE2 = 5                     --���ָ�����2��Ϣ,����ʾ���
SHLPLT_WELFARE3 = 6                     --���ָ�����3��Ϣ,����ʾ���
SHLPLT_PRIVACY = 7                      --���˽���
SHLPLT_NUM = 8
--to C++ enum [SeHoodleLotteryPoolType] Define END

--to C++ enum [SeHoodleLotteryQueryType] Define BEGIN
SHLQT_NULL = 0                          --��Ч
SHLQT_BASE = 1                          --������Ϣ
SHLQT_START_LOTTERY = 2                 --��ʼ����
SHLQT_OPEN_INFO = 3                     --���ؿ������
SHLQT_TEN_LOTTERY = 4                   --һ�ε�ʮ��
SHLQT_PRIVACY_INFO = 5                  --���˽�����Ϣ
SHLQT_NUM = 6
--to C++ enum [SeHoodleLotteryQueryType] Define END

--to C++ enum [SeHoodleBoxProgressType] Define BEGIN
SHBPT_NULL = 0                          --��Ч
SHBPT_LEFT = 1                          --��1��
SHBPT_RIGHT = 2                         --��1��
SHBPT_MID = 3                           --��1��
SHBPT_NUM = 4
--to C++ enum [SeHoodleBoxProgressType] Define END

--to C++ enum [SeHoodleBallType] Define BEGIN
SHBT_NULL = 0                           --��Ч
SHBT_NORMAL = 1                         --��ͨ��
SHBT_SPECIAL = 2                        --���³�����ʮ����
SHBT_DAILYFREE = 3                      --���³�ÿ�������
SHBT_FORTENSHOOT = 4                    --�ۼ�ʮ����
SHBT_NUM = 5
--to C++ enum [SeHoodleBallType] Define END

--to C++ enum [SeHoodlePrivacyChivalrousType] Define BEGIN
SHPCT_NULL = 0                          --��Ч
SHPCT_NORMAL = 1                        --���³�:���¾�Ӣ
SHPCT_CHIVALROUS_1 = 2
SHPCT_CHIVALROUS_2 = 3
SHPCT_CHIVALROUS_3 = 4
SHPCT_CHIVALROUS_4 = 5
SHPCT_CHIVALROUS_5 = 6
SHPCT_CHIVALROUS_6 = 7
SHPCT_NUM = 8
--to C++ enum [SeHoodlePrivacyChivalrousType] Define END

--to C++ enum [SeManagerType] Define BEGIN
SMT_INSTROLE = 0
SMT_NPCROLE = 1
SMT_ITEM = 2
SMT_MARTIAL = 3
SMT_SHOP = 4
SMT_TASK = 5
SMT_MAP = 6
SMT_GIFT = 7
SMT_CITY = 8
SMT_PLOT = 9
--to C++ enum [SeManagerType] Define END

--to C++ enum [SeRegisterRet] Define BEGIN
SRR_SUCCESS = 0
SRR_REPEAT = 1
SRR_VERSION = 2
SRR_FAILED = 3
--to C++ enum [SeRegisterRet] Define END

--to C++ enum [SeNoticeCode] Define BEGIN
SNC_UNKNOW = 0                          --δ֪
SNC_CHAR_NAME_INVALID = 1               --��ɫ���ֺ��зǷ��ַ�
SNC_SKIN_UNLOCK_SUC = 2                 --Ƥ�������ɹ�
SNC_RENAME_FAIL = 3                     --����ʧ��
SNC_ACCOUNT_WILL_LOGIN = 4              --�ʺ��ڼ�������¼
SNC_ACTION_SWITCH_OFF = 5               --��Ҫ���ݿ�Ĺ��ܿ��ر�����, ��Ӧ����ö��ֵSeDBRelatedSwitch
SNC_CHANGE_NATIONALITY_FAIL = 6         --�ı����ʧ��
SNC_USE_BAG_ITEM_SUCCESS = 7            --��������ʹ�óɹ�
SNC_USE_BAG_ITEM_FAILED = 8             --��������ʹ��ʧ��
SNC_SELL_BAG_ITEM_SUCCESS = 9           --�������߳��۳ɹ�
SNC_SELL_BAG_ITEM_FAILED = 10           --�������߳���ʧ��
SNC_BAG_ITEM_NEED_LEVEL = 11            --������Ҫ�ȼ�����ʹ��
SNC_SERVER_ERROR = 12                   --�������ֹ���
SNC_GAMEFUC_OFF = 13                    --��������
SNC_QUERY_OFFLINE_PLAYER = 14           --��������޷���ѯ
SNC_QUERY_TOO_FREQUENTLY = 15           --��ѯ����Ƶ��
SNC_USE_ITEM_MANUAL_FULL = 16           --ʹ�õ���ʧ����������
SNC_CHAR_CHARGED_MONEY = 17             --����ۼƳ�ֵ
SNC_CHAR_NAME_OVER_LEN = 18             --���ֳ���������
SNC_PLAT_PLAYER_OFFLINE = 19            --������Ѿ�����
SNC_RENAME_USE_SPECIAL_SYMBOL = 20      --����ʹ���������ַ�
SNC_RENAME_USE_GOLDOPRFREQUENT = 21     --����̫Ƶ��
SNC_PITOSDILATATION = 22                --���ݳɹ�
SNC_PITOSDILATATION_LIMIT = 23          --�����ݵĸ����Ѵ�����
SNC_SHOPREWARDEXCEPT = 24               --�̵����ʧ��
SNC_SHOPGOLDREWARDSUCCESS = 25          --�̵�𶧴��ͳɹ�
SNC_SHOPADREWARDSUCCESS = 26            --�̵�����ͳɹ�
SNC_OPENTREASURE_FRIENDGIFT = 30        --����ر�ͼ���������ѽ���
SNC_LIMITBUY_BAG_NOT_ENOUGH = 31        --�������Ӳ���
SNC_COMMON = 100                        --ͨ��֪ͨ��ֱ�Ӷ�ȡ�ַ���������
SNC_COMMON_SUC = 101                    --�ɹ���ʾ
SNC_NOT_ENOUGH_GOLD = 102               --�𶧲���
SNC_NOT_ENOUGH_SILVER = 103             --��������
SNC_NOT_ENOUGH_HOODLESCORE = 104        --ͷ����
SNC_HOODLEBUY_SUCCESS = 105             --ͷ��һ���Ʒ�ɹ�
SNC_HOODLEBUY_NOMATCH = 106             --ͷ��һ���Ʒ��ƥ��
SNC_SUC_SEND_REDPACKET = 110            --������ͳɹ�
SNC_NOT_SEND_REDPACKET = 111            --�������ʧ��
SNC_SUC_GETREDPACKET = 112              --�����ȡ�ɹ�
SNC_NOT_EXIST_REDPACKET = 113           --���������
SNC_HADGET_REDPACKET = 114              --�������ȡ
SNC_NOT_ENOUGH_REDPACKET = 115          --����ѱ���ȡ��
SNC_OVERTIME_REDPACKET = 116            --����ѹ���
SNC_NODATA_REDPACKET = 117              --������ݴ���
SNC_FORBIDTEXT_REDPACKET = 118          --��������Ƿ��ַ�
SNC_NOITEM_REDPACKET = 119              --������߲���
SNC_GETTIMESMAX_REDPACKET = 120         --��������ȡ���Ѵ�����
SNC_LIMITSHOP_FINFIRSTSHARE = 130       --�״η������
SNC_LIMITSHOP_ADDFIRSTSHARE = 131       --��ӷ���ɹ�
SNC_LIMITSHOP_ADDDISCOUNT = 132         --�Ż�ȯ��ӳɹ�
SNC_LIMITSHOP_NOENOUGHBIGCOIN = 133     --���ӱҲ���
SNC_LIMITSHOP_NOENOUGHYAZHUTIMES = 134  --Ѻע����������
SNC_LIMITSHOP_BUYBIGCOINSUCCESS = 135   --������ӱҳɹ�
SNC_LIMITSHOP_YAZHUSUCCESS = 136        --Ѻע�ɹ�
SNC_LIMITSHOP_ADDDISCOUNTLIMIT = 137    --�Ż�ȯ�����Ѵ�����
SNC_LIMITSHOP_GETYAZHUINROFIRST = 138   --�����Ȼ�ȡѺע��Ϣ
SNC_LIMITSHOP_YAZHUGAMEOVER = 139       --Ѻע�����
SNC_LIMITSHOP_BUYSECCESS = 140          --����ɹ�
SNC_LIMITSHOP_COUPONNOTFOUND = 141      --�Ż�ȯ������
SNC_LIMITSHOP_COUPONEXPIRED = 142       --�Ż�ȯ�ѹ���
SNC_LIMITSHOP_GIFTSOLD = 143            --���������
SNC_TASK_COMPLETE = 350                 -- ������ ������ʾ��Ӧ������ID
SNC_TASK_RESET_FAIL = 351               -- ��������ʧ��
SNC_TASK_AWARD_GET = 352                -- �Ѿ���ȡ������
SNC_TASK_TIME_UP = 357                  --����ʱ��
SNC_DEL_TASK_EXCHANGE = 358             --ɾ���һ�����
SNC_FAILED_TASK_EXCHANGE = 359          --���߶һ�ʧ��
SNC_MAPTASK_AWARD_GET = 360             -- �Ѿ���ȡ��ͼ������
SNC_RACE_WEEK_GOLD_LIMIT = 361          -- �����Ҵﵽ������
SNC_ONLINEBOX_UNLOCK_FAIL = 365         --���߱������ʧ��
SNC_ONLINEBOX_OPEN_FAIL = 366           --���߱��俪��ʧ��
SNC_NEW_FOLLOWER_NOTIFY = 380           --���µķ�˿
SNC_FRIEND_UNFOLLOW = 381               --����˿ȡ����ע
SNC_FRIEND_ADD_FAIL_MAXIMUM = 382       --��Ӻ���ʧ��-�ﵽ�������
SNC_FRIEND_ADD_OFFLINE = 383            --��Ӻ���ʧ��-���������δ���߹������
SNC_IN_DIFF_TOWN = 384                  --����ͬ����
SNC_FIND_PLAYER_OFFLINE = 385           --�����������
SNC_START_DUEL_FAIL_RET = 386           --��ʼ����ʧ�ܷ���ֵ��param��ʾ���ɣ�1����ս����������Լ���2���Լ��ǿ��У�3���˷ǿ���,4����ս��Ҳ��ٰ���5��ս������ȴ�У��Ժ�����6�����仯
SNC_DUEL_CLOSE = 387                    --����ر�֪ͨ��һ�������������Լ�ʱ�ص�
SNC_FORBIDADDFRIEND = 388               --����ֹ��Ӻ���
SNC_SHOP_SUCCESS = 500                  --���׳ɹ�
SNC_SHOP_UNKNOWN_ERROR = 501            --δ֪����
SNC_SHOP_ITEM_NOT_EXIST = 502           --��Ʒ������
SNC_SHOP_NOT_ENOUGH_MONEY = 503         --Ǯ����
SNC_SHOP_MAX_BUY_NUM = 504              --���������
SNC_SHOP_NOT_ENOUGH_FAVORABILITY = 505  --�ƶ�Ȳ���
SNC_SHOP_SELL_NOT_ENOUGH_NUM = 506      --����û���㹻������
SNC_SHOP_RESERVE = 599                  --����
SNC_ARENA_NOT_IN_SIGNUP_TIME = 600      --���ڱ���ʱ��
SNC_ARENA_UPDATE_PKDATA_SUCCESS = 601   --����PK���ݳɹ�
SNC_ARENA_HAS_BET = 602                 --�ظ�Ѻע
SNC_ARENA_BET_FAILED = 603              --Ѻעʧ��
SNC_ARENA_SIGNUP_FAILED = 604           --����ʧ��
SNC_ARENA_NEED_CHAMPION_TIEMS_1 = 605   --����ʧ��,��Ҫ�ھ�����
SNC_ARENA_NEED_CHAMPION_TIEMS_2 = 606   --����ʧ��,��Ҫ�ھ�����
SNC_APPEAR_MODIFY_SUC = 700             --�޸ĳɹ�
SNC_APPEAR_MODIFY_PARAM_FAIL = 701      --��������
SNC_APPEAR_MODIFY_NOT_HAVE = 702        --δӵ��
SNC_APPEAR_MODIFY_SAME_NAME = 703       --����
SNC_APPEAR_MODIFY_NAME_FREQUENTLY = 704 --ƽ̨��������Ƶ��
SNC_TSS_NOT_VALID = 800                 --����������
SNC_PUBLIC_CHAT_FREQUENCY_TOO_HIGH = 900--����Ƶ��̫��
SNC_PUBLIC_CHAT_CHANNEL_INVALID = 901   --����Ƶ������
SNC_FORBIDDEN_CHAT = 902                --���ѱ�����
SNC_FORBIDDEN_SILENTCHAT = 903          --���ѱ���Ĭ
SNC_BECOME_RMB_PLAYER = 950             --��ͨ�ٱ���
SNC_TREASURE_ADVANCE_PURCHASE_SUC = 951 --��Լ�¿��ɹ�
SNC_TREASURE_ADVANCE_PURCHASE_FAIL = 952--��Լ�¿�ʧ��
SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_SUC = 953--������Լ�¿��ɹ�
SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_FAIL = 954--�����ѱ���Լ�¿�
SNC_TREASURE_BUT_EXP_SUC = 955          --������ɹ�
SNC_TREASURE_DAILY_SILVER_SUC = 956     --ÿ��������ȡ�ɹ�
SNC_TREASURE_DAILY_SILVER_FAIL = 957    --ÿ��������ȡʧ��
SNC_TREASURE_WEEK_SILVER_SUC = 958      --ÿ��������ȡ�ɹ�
SNC_TREASURE_WEEK_SILVER_FAIL = 959     --ÿ��������ȡʧ��
SNC_TREASURE_TASK_PROGRESS_UPDATE = 960 --������ȸ���
SNC_BECOME_RMB_PLAYER_FAIL = 961        --��ͨ�ٱ���ʧ��
SNC_UNLOCK_NEW_EXTRA_HERO_TASK = 962    --�������µ�Ӣ�������
SNC_UNLOCK_NEW_EXTRA_RMB_TASK = 963     --�������µĺ��������
SNC_UNLOCK_NEW_REPEAT_TASK = 964        --�������µ��ظ�����
SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_LIMIT = 965--�����˱��¿���Լ�¿��ĺ�������
SNC_TREASURE_CUR_EXP = 966              --ͬ����ǰ�ٱ��龭��
SNC_TREASURE_EXTRA_GETREWARD_LVL = 967  --��ǰ�ٱ��������ȡ���ĵȼ�
SNC_TREASURE_FRIEND_RMB_NUM = 968       --�����к�������
SNC_HOODLE_NUM_NOT_ENOUGH = 970         --������������
SNC_HOODLE_PUBLIC_NOT_READY = 971       --ȫ�������й��ܹ���
SNC_HOODLE_PRIVACY_NOT_OPEN = 972       --�����и��˽���δ����
SNC_HOODLE_MOJUN_SURVIVAL_NOT_RESET = 973--ħ�����ڣ������и��˽�������ʧ��
SNC_HOODLE_NOT_SAME_POOL_ID = 974       --����ID��һ�£�������Ϣͬ������
SNC_MERIDIANS_EXP_CHANGE = 990          --��������ı�
SNC_MERIDIANS_BREAK_ITEM_NOT_ENOUGH = 991--���鵤����
SNC_MAX_DAILY_MERIDIANS_EXP = 992       --�����Ѵﵽ���ɻ�þ�����������
SNC_CHALLENGE_ORDER_UNLOCK = 1000       --��ս������ɹ�
SNC_DAY3SIGNIN_BUY_HORSE = 1003         --����ɹ�
SNC_DAY3SIGNIN_JOIN_TEAM = 1004         --��ӳɹ�
SNC_UNLOCK_INFO = 1050                  --����֪ͨ
SNC_UNLOCK_ADD_INCOMPLETETEXT = 1051    --������ѧ���Ӳ���ֵ
SNC_UNLOCK_STORY = 1052                 --�����籾֪ͨ
SNC_SHOW_PET = 1060                     --�ɹ�����չʾ����
SNC_UNLOCK_PET = 1061                   --�ɹ���������
SNC_CLEAR_ROLE_CARD = 1062              --�����ɫ����ת������Դֵ
SNC_CLEAR_PET_CARD = 1063               --������￨��ת������Դֵ
SNC_GOLD_OP_EXCEPT = 1100               --�����쳣,�Ժ�����
SNC_PLAT_EMBATTLE_NO_EFFECT = 1110      --ƽ̨������Ч
SNC_TENCENT_CREDIT_SCORE_SCENE_LIMIT = 1120--���÷ֲ���
SNC_OperatorSignInFlagRet = 1130        --7��ǩ���������� ���ݲ������ͽ���
SNC_PlatChallengeCD = 1131              --ƽ̨�д�cd��ȴ��
SNC_PlatChallengeTargetOffline = 1132   --ƽ̨�д豻�д����������
SNC_OTHER_BUILDING_UPGRADE = 1200       --������������������
SNC_BUILDING_MAX_LEVEL = 1201           --�Ѿ�������߼���
SNC_NOT_ENOUGH_MATERIAL = 1202          --�������ϲ���
SNC_BUILDING_PUT_INVALID = 1203         --���ý����Ƿ�
SNC_NOT_ENOUGH_HALL_LEVEL = 1204        --�����ȼ�����
SNC_NO_MATERIAL_GET = 1205              --��ǰû�в��Ͽ�����ȡ
SNC_DISCIPLE_NOT_IN_ROOM = 1206         --�õ��Ӳ��ڵ��ӷ�
SNC_DISCIPLE_IN_OTHER_BUILDING = 1207   --�õ���������������
SNC_DISCIPLE_ROOM_INVALID = 1208        --���ӷ�δ��������δ����
SNC_DISCIPLE_ROOM_FULL = 1209           --���ӷ��ô�������
SNC_DISCIPLE_LIMIT = 1210               --�������Ѵ�����
SNC_BUILDING_NAME_INVALID = 1211        --������������
SNC_BUILDING_NAME_OVER_LIMIT = 1212     --���Ƴ��ȳ���
SNC_ACTIVITY_RECEIVE_FAILED = 1300      --���ȡʧ��
SNC_ACTIVITY_FUND_SUCCESS = 1301        --�����ͨ�ɹ�
SNC_ACTIVITY_FUND_FAIL = 1302           --�����ͨʧ��
SNC_ACTIVITY_FUND_GETFAIL = 1303        --��ȡʧ��,��������
SNC_ACTIVITY_FESTIVAL_SIGN_IN_RES = 1304--���ջ��Ծ�Ƚ�����ȡ���
SNC_ACTIVITY_FESTIVAL_LIVENESS_ACHIEVE_RES = 1305--���ջ��Ծ�Ƚ�����ȡ���
SNC_ACTIVITY_FESTIVAL_EXCHANGE_RES = 1306--���ջ�һ����
SNC_ACTIVITY_FESTIVAL_EXCHANGE_ASSET_CLEAN_RES = 1307--���ջ�ʲ�ֵ��ս��
SNC_ACTIVITY_FESTIVAL_BUYMALL_RES = 1308--���ջ��Ʒ������
SNC_TREASURE_EXCHANGE_REFREASH = 1310   --�ر�ˢ�³ɹ�
SNC_TREASURE_EXCHANGE_REFREASH_FAILED = 1311--�ر�ˢ��ʧ��
SNC_TREASURE_EXCHANGE_BUY_FAILED = 1312 --�ر��һ�ʧ��
SNC_TREASURE_EXCHANGE_BUY = 1313        --�ر��һ��ɹ�
SNC_SCRIPT_ENTER_LIMIT = 1500           --�籾���ȵȴ�����
SNC_FREE_CHALLENGE_UNLOCK_FAILD = 1501  --������������ʧ��
SNC_ILLEGAL_ENTER_STORY_DIFFICULT = 1502--����籾�Ѷ��쳣����Ҫ�Զ��籾����
SNC_SYS_RED_PACKET_HUASHAN = 1600       --��ɽ�۽���һϵͳ���
SNC_SYSTEM_MODULE_DISABLE = 1700        --ϵͳģ��ά������ʾ
SNC_ANTI_ADDITION = 1800                --������
SNC_WEGAME_EXIT = 1801                  --wegame�˳�
--to C++ enum [SeNoticeCode] Define END

--to C++ enum [SeLoginReason] Define BEGIN
LFR_SUCCESS = 0                         --��½�ɹ�
LFR_UNKONW_REASON = 1                   --δ��������
LFR_DB_ERROR = 2                        --��ѯ���ݿ����
LFR_ACCOUNT_ERROR = 3                   --�ʺŻ����������
LFR_ACCOUNT_VERITYFY = 4                --�ͻ�����֤����
LFR_SERVER_DISCONNECT = 5               --������δ����
LFR_SERVER_BUSY = 6                     --��������æ
LFR_SESSION_ERROR = 7                   --�ỰID����
LFR_OTHER_LOGGED = 8                    --���������ط���¼(������)
LFR_INVALID_PLAT = 9                    --�Ƿ��ĵ�¼ƽ̨��ʶ
LFR_WS_DB_ERROR = 10                    --WorldServer�������ݿ����
LFR_VERSION_ERROR = 11                  --�ͻ��˰汾�Ŵ���
LFR_HAS_LOCKED = 12                     --�˺��ѱ��� ,�˴���ʱ����һ���������ط��ԭ�򣬵ڶ�����������ʣ����ʱ�䣺xx��
LFR_SERVER_MAINTAIN = 13                --������ά����
LFR_SERVER_FULL = 14                    --�������������ﵽ����
LFR_TOKEN_ERROR = 15                    --��½token����
LFR_COUNTRY_ERROR = 16                  --���Ҵ���
LFR_SLAVE_SERVER_CANNOT_FIND_DATA = 17  --�ӷ������޷���֤����
--to C++ enum [SeLoginReason] Define END

--to C++ enum [SeLoginPlatType] Define BEGIN
SLPT_None = 0                           --δ��½
SLPT_Weixin = 1                         --΢�ŵ�½
SLPT_QQ = 2                             --QQ��½
SLPT_WTLogin = 3                        --WT��½
SLPT_QQHall = 4                         --��Q������½
SLPT_Guest = 5                          --�ο͵�½
SLPT_Auto = 6                           --�ϴε�½
SLPT_PC = 7                             --PC��½
--to C++ enum [SeLoginPlatType] Define END

--to C++ enum [SePublicLoginChannelType] Define BEGIN
SPLCT_None = 0                          --δ֪
SPLCT_UserPwd = 1                       --�û�����
SPLCT_WX = 2                            --΢��
SPLCT_QQ = 3                            --QQ��½
SPLCT_TENCENT = 4                       --��Ѷ��¼���°�ͳһ����
SPLCT_Max = 4                           --���ID��¼
--to C++ enum [SePublicLoginChannelType] Define END

--to C++ enum [SePublicLoginResult] Define BEGIN
SPLR_OK = 0                             --��¼�ɹ�
SPLR_Unavailable = 1001                 --���񲻿���
SPLR_NotExists = 1002                   --�˻�������
SPLR_TokenWrong = 1003                  --�������
SPLR_QueueRequire = 1004                --��Ҫ�Ŷ�
SPLR_Freezing = 1005                    --�˻�������
SPLR_WhiteListOnly = 1006               --�������������¼
SPLR_Forbidden = 1007                   --�ܾ���½(�����ر�)
SPLR_ShutDown = 1008                    --ͣ��ά��
SPLR_Blocked = 1009                     --������ֹ(IP,ʱ��ε�����)
SPLR_ZoneLimit = 1010                   --������¼����
SPLR_FirstServerLimit = 1011            --���������ƴ���
--to C++ enum [SePublicLoginResult] Define END

--to C++ enum [SeTencentWordFilterType] Define BEGIN
STWFT_NULL = 0                          --��Чλ
STWFT_TALK = 1                          --����
STWFT_PLAT_RENAME = 2                   --ƽ̨����
STWFT_SCRIPT_RENAME = 3                 --�籾����
STWFT_REDPACKET_WORD = 4                --�������
STWFT_SECT_BUILDING_RENAME = 5          --���ɽ�������
STWFT_END = 6
--to C++ enum [SeTencentWordFilterType] Define END

--to C++ enum [SePublicChatChannelType] Define BEGIN
SPCCT_NULL = 0                          --��Чλ
SPCCT_WORLD = 1                         --����
SPCCT_SCRIPT = 2                        --�籾
SPCCT_HOUSE = 3                         --�ƹ�
SPCCT_PRIVATE = 4                       --˽��
--to C++ enum [SePublicChatChannelType] Define END

--to C++ enum [SeTLogMoneyType] Define BEGIN
STLMT_INVALID = 0                       --��Чλ
STLMT_COIN = 1                          --ͭ��
STLMT_SILVER = 2                        --����
STLMT_GOLD = 3                          --��
STLMT_TREASURE = 4                      --�ٱ����ҳ
STLMT_DRINK = 5                         --��ȯ
STLMT_PLATFORMSCORE = 6                 --ƽ̨����
STLMT_ACTIVEFORMSCORE = 7               --�����
STLMT_SECONDGOLD = 8                    --���
STLMT_HOODLESCORE = 9                   --�ᱦ����
STLMT_ZMGOLD = 10                       --���ű�
--to C++ enum [SeTLogMoneyType] Define END

--to C++ enum [SeTLogProperType] Define BEGIN
STLPT_INVALID = 0                       --��Чλ
STLPT_FORGET = 1                        --���ǲ�
STLPT_IRON = 2                          --����
STLPT_PERFECT = 3                       --������
STLPT_MERIDIANS_BREAK = 4               --���鵤
STLPT_MERIDIANS_EXP = 5                 --��������
STLPT_LUCKY_BALL = 6                    --������
STLPT_HOODLE_BALL = 7                   --С����
STLPT_FESTIVAL_VALUE1 = 8               --���ջ�ʲ�ֵ1(���ջͨ���ʲ�ֵ, �ڶ�ѩ����, ��ʾѩ��)
STLPT_FESTIVAL_VALUE2 = 9               --���ջ�ʲ�ֵ2(���ջͨ���ʲ�ֵ, �ڶ�ѩ����, ��ʾ��ѩ�øж�)
STLPT_HEAVEN_HAMMER = 10                --�칤��
STLPT_TONGLINGYU = 11                   --ͨ����
--to C++ enum [SeTLogProperType] Define END

--to C++ enum [RecordLogFlowReason] Define BEGIN
RLFR_NULL = 0
RLFR_System = 1
RLFR_System_GM = 2
RLFR_System_Mail = 3
RLFR_Recharge = 100                     --��ֵ
RLFR_Recharge_Midas = 101               --�״�ʦ
RLFR_FinishScript = 200                 --�����Ŀ
RLFR_FinishScript_Reward = 201          --�籾����
RLFR_FinishScript_Item = 202            --��Ŀ�����Ʒ
RLFR_Talk = 300
RLFR_Talk_Small = 301                   --����
RLFR_Talk_World = 302                   --��������
RLFR_Talk_World_Back = 303              --�������쳡������������ԭ����첽�ۿ��˻�
RLFR_Drop = 400                         --����
RLFR_Drop_Treasure = 401                --����
RLFR_Drop_Little_Monster = 402          --С��
RLFR_Drop_Elite_Monster = 403
RLFR_Drop_Boss_Monster = 404            --BOSS
RLFR_Drop_Maze = 405                    --�Թ�����,������
RLFR_Drop_City = 406                    --���е���,������
RLFR_Drop_Adventure = 407               --ð���ռ�
RLFR_Drop_HoodleLottery = 408           --������
RLFR_Drop_Map = 409                     --��ͼ���
RLFR_Drop_Role = 410                    --��ɫ������Ʒ
RLFR_Task = 500                         --����
RLFR_Task_Entrust = 501                 --ί��
RLFR_Task_Award = 502                   --����
RLFR_Shop = 600                         --�̵�
RLFR_Shop_Normal = 601                  --��ͨ�̵�
RLFR_Shop_Mystery = 602                 --�����̵�
RLFR_Shop_Plat = 603                    --ƽ̨�̳�
RLFR_Shop_Limit = 604                   --��ʱ�̵�
RLFR_Shop_LimitRecharge = 605           --��ʱ�̵��ֵ
RLFR_Shop_YaZhu = 606                   --�Ĳ�
RLFR_Shop_Reward = 607                  --�̳Ǵ���
RLFR_Shop_Zm = 608                      --�����̵�
RLFR_Shop_RepeatFormula = 609           --�ظ��䷽���
RLFR_Refresh = 800                      --ˢ��
RLFR_Refresh_Wish = 801                 --ˢ����Ը
RLFR_Refresh_Talent = 802               --ˢ���츳
RLFR_Refresh_Begging = 803              --ˢ������
RLFR_Refresh_Challenge = 804            --ˢ���д�
RLFR_Refresh_Consult = 805              --ˢ�����
RLFR_Refresh_CallUp = 806               --ˢ�º���
RLFR_Refresh_Punish = 807               --ˢ�³Ͷ�
RLFR_Refresh_Inquiry = 808              --ˢ���̲�
RLFR_Refresh_Duel = 809                 --ˢ�¾���
RLFR_Refresh_Steal = 810                --ˢ��͵ѧ
RLFR_Refresh_ReCast = 811               --ˢ������
RLFR_Refresh_Strengthen = 812           --ˢ��ǿ��
RLFR_Refresh_Smelt = 813                --ˢ������
RLFR_NPCAct = 1000                      --NPC����
RLFR_NPCAct_Begging = 1001              --����
RLFR_NPCAct_Challenge = 1002            --�д�
RLFR_NPCAct_Duel = 1003                 --����
RLFR_NPCAct_Gift = 1004                 --����
RLFR_NPCAct_EnterClan = 1005            --��������
RLFR_NPCAct_Punish = 1006               --�Ͷ�
RLFR_Meridians = 1100                   --����
RLFR_Meridians_ExpLimit = 1101          --�ܾ���������������
RLFR_Meridians_ExpBuyItem = 1102        --�����ӹ����鵤����
RLFR_Meridians_Break = 1103             --���鵤����
RLFR_Meridians_Cheat = 1104             --����ָ��
RLFR_Meridians_RedPacket = 1105         --���
RLFR_Meridians_Item = 1106              --ʹ�õ���
RLFR_Meridians_Hoodle = 1107            --��������
RLFR_Meridians_ScriptOver = 1108        --��Ŀ����
RLFR_Meridians_LvlUp = 1109             --��������
RLFR_Meridians_ActivityResExchange = 1110--���Դת��
RLFR_Unlock = 1200                      --����
RLFR_Unlock_Role = 1201                 --������ɫ
RLFR_Unlock_Difficulty = 1202           --�����Ѷ�
RLFR_Unlock_Skin = 1203                 --����Ƥ��
RLFR_Unlock_Story = 1204                --�����籾
RLFR_Unlock_LoginWord = 1205            --������¼��
RLFR_Unlock_Repeat = 1206               --�ظ�����
RLFR_Unlock_RoleFace = 1207             --����������λ
RLFR_Unlock_RoleFaceModel = 1208        --��������ģ��
RLFR_Equipment = 1300                   --װ��
RLFR_Equipment_Make = 1301              --װ������
RLFR_Equipment_Remake = 1302            --����
RLFR_Equipment_LvlUp = 1303             --����
RLFR_Equipment_Smelting = 1304          --����
RLFR_Equipment_Repair_Crack = 1305      --�޸��Ѻ�
RLFR_Lottery = 1400                     --С����
RLFR_Lottery_Once = 1401
RLFR_Lottery_Ten = 1402
RLFR_Lottery_PublicReward = 1403        --ȫ��С���ͽ���
RLFR_Lottery_KillScore = 1404           --С���ͻ�ɱ��Ի���
RLFR_Lottery_BuyItem = 1405             --��Ի��ֶһ���Ʒ
RLFR_Lottery_Daily = 1406               --ÿ������
RLFR_Lottery_BuyTen = 1407              --�齱������������ʮ��
RLFR_Lottery_BuyOnce = 1408             --�齱�����������򵥳�
RLFR_UseItem = 1600                     --ʹ����Ʒ
RLFR_UseItem_RunShop = 1601
RLFR_UseItem_Sell = 1602
RLFR_UseItem_PiecesOFSilver = 1603      --ʹ������
RLFR_UseItem_AUTO = 1604                --�Զ�ʹ����Ʒ
RLFR_UseItem_CHOOSEGIFT = 1605          --���
RLFR_UseItem_PlatUse = 1606             --�ƹݲֿ���ʹ��
RLFR_UseItem_ForgetMartial = 1607       --���ǲ�
RLFR_UseItem_MakeSecretCostSilver = 1608--��ѧ�հ���
RLFR_UseItem_AddIncompleteBook = 1609   --���Ӳ���
RLFR_UseItem_AddGift = 1610             --ʹ������
RLFR_UseItem_EatFood = 1611             --ʹ�ò���
RLFR_UseItem_OpenTask = 1612            --��������
RLFR_UseItem_Drop = 1613                --ִ�е��䷽��
RLFR_UseItem_GameProperties = 1614      --��������
RLFR_UseItem_MazeRestore = 1615         --�Թ�(����)�ָ�
RLFR_UseItem_AddBuff = 1616             --�Թ����Buff
RLFR_UseItem_UnlockRecipe = 1617        --�����䷽
RLFR_UseItem_TreasureMap = 1618         --�ر�ͼ
RLFR_UseItem_Behavior = 1619            --ִ����Ϊ
RLFR_UseItem_Disguise = 1620            --�������
RLFR_UseItem_BoboTicket = 1621          --������Ʊ
RLFR_UseItem_DanYao = 1622              --��ҩ
RLFR_UseItem_Lottery = 1623             --��Ʊ�齱
RLFR_UseItem_GetBaby = 1624             --ʹ����ͽ��
RLFR_UseItem_RoleCard = 1625            --��ɫ��
RLFR_UseItem_PetCard = 1626             --���￨
RLFR_UseItem_BingHuoCanShi = 1627       --�����ʬ��
RLFR_UseItem_CallHelper = 1628          --����Ч��
RLFR_UseItem_Equip = 1629               --װ������
RLFR_UseItem_RenameCard = 1630          --���͸�����
RLFR_UseItem_CuiLian = 1631             --(�൶)����
RLFR_UseItem_ADVGIFT = 1632             --ð���츳
RLFR_UseItem_CarryIn = 1633             --����籾
RLFR_UseItem_MoveSerectBook = 1634      --ת���ؼ�(�����ѵ�)
RLFR_UseItem_NPCRandomItem = 1635       --���NPC��Ʒ
RLFR_UseItem_SubmitItem = 1636          --�ύ��Ʒ��NPC
RLFR_UseItem_NormalHighTower = 1637     --����ǧ�������
RLFR_UseItem_BloodHighTower = 1638      --Ѫ��ǧ�������
RLFR_UseItem_RegimentHighTower = 1639   --��սǧ�������
RLFR_UseItem_AddClanDisposition = 1640  --�޸����ɺø�
RLFR_UseItem_Click = 1641               --�������ʹ��
RLFR_UseItem_AbsorbDrop = 1642          --���ܵ�����
RLFR_Evolution = 1700                   --�ݻ�
RLFR_Recycling = 1800                   --����
RLFR_Recycling_RoleCard = 1801          --��ɫ������
RLFR_Recycling_PetCard = 1802           --���￨����
RLFR_Recycling_PlatItem = 1803          --ƽ̨��Ʒ����
RLFR_Plot = 1900                        --����
RLFR_Exchange = 2000                    --�һ�
RLFR_Exchange_Silver = 2001             --�һ�����
RLFR_Exchange_Add_BagCapacity = 2002    --���䱳������
RLFR_Exchange_LuckyValue = 2003         --����ֵ�һ�
RLFR_Exchange_Dilatation = 2004         --�ֿ����籾����
RLFR_TreasureBook = 2100                --�ٱ���
RLFR_TreasureBook_FreeDay = 2101        --ÿ����ȡ
RLFR_TreasureBook_FreeDWeek = 2102      --ÿ����ȡ
RLFR_TreasureBook_LvlReward = 2103      --�ȼ�����
RLFR_TreasureBook_BRMB = 2104           --��ͨ����
RLFR_TreasureBook_AdvancePurchase = 2105--Ԥ���¿�
RLFR_TreasureBook_BuyExp = 2106         --������
RLFR_TreasureBook_Mall = 2107           --�̳Ƕһ�
RLFR_TreasureBook_GlobalReward = 2108   --ȫ������
RLFR_TreasureBook_ClearCoupon = 2109    --��ĩ����Ż�ȯ
RLFR_TreasureBook_GiveOther = 2110      --���ͺ���
RLFR_Mail = 2200                        --�ʼ�
RLFR_Mail_AddGold = 2201                --���ӽ�(�ʼ���ȡ)
RLFR_Mail_Item = 2202                   --�ʼ���Ʒ
RLFR_Mail_FriendTreasureBook = 2203     --�����¿�
RLFR_Achieve = 2300                     --�ɾ�
RLFR_Achieve_Receive = 2301             --��ȡ�ɾͽ���
RLFR_Temple = 2400                      --����
RLFR_Temple_Pray = 2401                 --����
RLFR_Temple_Forgive = 2402              --��Թ
RLFR_Arean = 2500                       --��̨��
RLFR_Arean_Bet = 2501                   --��̨��Ѻע
RLFR_Zm = 2550                          --���ŶԾ�
RLFR_Zm_Match = 2551                    --���ŶԾ���Ʊ
RLFR_Discount = 2600                    --�Ż�
RLFR_Discount_Coupon = 2601             --�ۿ�ȯ
RLFR_Appearance = 2700                  --����
RLFR_Appearance_ReName = 2701           --����
RLFR_ChallengeOrder = 2800              --��ս��
RLFR_ChallengeOrder_Mid = 2801          --��ս���м�
RLFR_ChallengeOrder_High = 2802         --��ս��߼�
RLFR_LearnSkill = 3000                  --ѧϰ����
RLFR_LearnSkill_Begging = 3001          --ѧϰ����
RLFR_LearnSkill_Duel = 3002             --ѧϰ����
RLFR_LearnSkill_Recast = 3003           --ѧϰ����
RLFR_LearnSkill_Strengthen = 3004       --ѧϰǿ��
RLFR_LearnSkill_Smelt = 3005            --ѧϰ����
RLFR_LearnSkill_QingJiao = 3006         --ѧϰ���
RLFR_LearnSkill_TouXue = 3007           --ѧϰ͵ѧ
RLFR_LearnSkill_QieCuo = 3008           --ѧϰ�д�
RLFR_LearnSkill_CallUp = 3009           --ѧϰ����
RLFR_LearnSkill_Punish = 3010           --ѧϰ�ͽ�
RLFR_LearnSkill_Inquiry = 3011          --ѧϰ�̲�
RLFR_LearnSkill_GiftRefresh = 3012      --�츳ˢ��
RLFR_LearnSkill_WishTaskRewardRefresh = 3013--��Ըˢ��
RLFR_NewPlayer = 3200                   --�½��˺�
RLFR_NewPlayer_LoginReward = 3201       --���ֵ�¼����
RLFR_IDIP = 3500                        --IDIP
RLFR_IDIP_AddGold = 3501                --idip���ӽ�
RLFR_IDIP_DescGold = 3502               --idip�۳���
RLFR_RedPacket = 3700                   --���
RLFR_RedPacket_DescSilver = 3701        --����۳�����
RLFR_RedPacket_GetItem = 3702           --��ȡ���
RLFR_RedPacket_SendFailBackItem = 3703  --�������ʧ���˻ص���
RLFR_RedPacket_SendFailBackSilver = 3704--�������ʧ���˻�����
RLFR_RedPacket_UseItem = 3705           --������ͳɹ����ĵ���
RLFR_Battle = 4100                      --ս��
RLFR_Battle_Pet = 4101                  --ս������ӳ�
RLFR_Battle_PlatChallenge = 4102        --ƽ̨�д�
RLFR_Battle_CallMaster = 4103           --���и���
RLFR_Daily = 4200                       --ÿ��
RLFR_Daily_Free = 4201                  --ÿ����ѽ���
RLFR_Daily_Day3SignIn = 4202            --3��ǩ��
RLFR_Daily_Day7SignIn = 4203            --7��ǩ������
RLFR_Daily_Challenge = 4204             --ÿ�������潱��
RLFR_Activity = 4300                    --�
RLFR_Activity_Wechat_ShareFriend = 4301 --ÿ��΢�ŷ�����ѽ���
RLFR_Activity_TreasureExchange_Refresh = 4302--�ر��-ˢ�¶һ���
RLFR_Activity_TreasureExchange_Reward = 4303--�ر��-�һ�����
RLFR_Activity_PreExprience_Reward = 4304--��������-�һ����ֽ���
RLFR_Activity_BackFlowPoint_Reward = 4305--�����-�һ����ֽ���
RLFR_Activity_BackFlow_Reward = 4306    --�����-�һ�����
RLFR_Activity_Fund_Reward = 4307        --��������
RLFR_Activity_Fund_Open = 4308          --������ͨ
RLFR_Activity_Festival_SignIn = 4309    --����ǩ�������
RLFR_Activity_Festival_DialyTask_Achieve = 4310--���ջÿ��������
RLFR_Activity_Festival_Liveness_Achieve = 4311--���ջ��Ծ�Ƚ���
RLFR_Activity_Festival_Exchange = 4312  --���ջ�һ�
RLFR_Activity_Festival_BuyMall = 4313   --���ջ�̵�
RLFR_Card = 4400                        --��Ƭ
RLFR_Card_LvlUp = 4401                  --�ȼ�����
RLFR_Card_BondUp = 4402                 --�����
RLFR_Card_Find = 4403                   --�ҵ���Ƭ(�������ͷ)
--to C++ enum [RecordLogFlowReason] Define END

--to C++ enum [SeTLogBattleType] Define BEGIN
STLBT_PVE = 0                           --ͭ��
STLBT_PVP = 1                           --����
STLBT_OTHER = 2                         --��
--to C++ enum [SeTLogBattleType] Define END

--to C++ enum [SeTLogTaskType] Define BEGIN
STLTT_INVALID = 0
STLTT_ENTRUST = 1                       --ί��
STLTT_MAIN = 2                          --����
STLTT_EXPERIENCE = 3                    --����
STLTT_ROLE = 4                          --��ɫ
STLTT_RUMORS = 5                        --����
STLTT_TREASURE = 6                      --�ٱ���
--to C++ enum [SeTLogTaskType] Define END

--to C++ enum [SeTLogReMakeType] Define BEGIN
STLRMT_INVALID = 0
STLRMT_IRON = 1                         --��������
STLRMT_COIN = 2                         --ͭ������
STLRMT_PERFECT = 3                      --��������
STLRMT_BLUE = 4                         --��������
STLRMT_ENHANCE = 5                      --ǿ��
--to C++ enum [SeTLogReMakeType] Define END

--to C++ enum [SeTLogPetActType] Define BEGIN
STLPAT_INVALID = 0
STLPAT_GET_PET = 1                      --��ó���
STLPAT_ASSISTANT = 2                    --��ս
STLPAT_CANCEL_ASSIS = 3                 --ȡ����ս
STLPAT_PLAT_ADD_DEBRIS = 4              --ƽ̨���ӳ�����Ƭ
STLPAT_SCRIPT_ADD_DEBRIS = 5            --�籾���ӳ�����Ƭ
--to C++ enum [SeTLogPetActType] Define END

--to C++ enum [SeTLogPlayerActType] Define BEGIN
STLPLAT_INVALID = 0
STLPLAT_ADD_FRIEND = 1                  --��Ӻ���
STLPLAT_DEL_FRIEND = 2                  --ɾ������
STLPLAT_CHALLENGE = 3                   --�д�
STLPLAT_WATCH = 4                       --�۲�
STLPLAT_RING_SIGN = 5                   --��̨����
STLPLAT_RING_CHEER = 6                  --��̨����
--to C++ enum [SeTLogPlayerActType] Define END

--to C++ enum [SeTLogUnlockType] Define BEGIN
STLULT_INVALID = 0
STLULT_CG = 1                           --����ͼ��
STLULT_FORMULA = 2                      --�䷽
STLULT_TREASURE = 3                     --���ұ�
STLULT_ROLE = 4                         --����
STLULT_SKIN = 5                         --Ƥ��
--to C++ enum [SeTLogUnlockType] Define END

--to C++ enum [SeValidateType] Define BEGIN
SVT_INVALID = -1                        --��Чλ
SVT_SESSION_ID_ERROR = 0                --�ỰID����
SVT_REPEAT_IN_TOWN = 1                  --�Ѿ��ڳ�������
SVT_NOT_LOAD_FINISH = 2                 --��:��δ�������,��:���ݿ��޷���
SVT_CANOT_SEND_VALID = 3                --��:���ݷ���ʧ������:DB��æ���߱���
SVT_LOAD_DATA_ERROR = 4                 --��:���ݶ�ȡ������:��¼���ݼ����з�������
SVT_LOAD_DATA_TOO_LONG = 5              --��:���������ݣ���:���ݿ���Ӧ̫��
SVT_CANOT_IN_HOUSE = 6                  --��:�ƹݱ�������:��Ӧ�̱߳���
SVT_ERROR_LOGIN_TOKEN = 7               --��:��¼У�������:��¼token����
SVT_ERROR_PROTO_SANGOMAGIC = 8          --��:��¼�汾������:α��Э��
SVT_ERROR_DB_CONNECT = 9                --��:����״̬�쳣����:�ظ���������״̬
SVT_SAME_REPLACEACCOUNT_ERROR = 10      --��:��ص�¼�쳣����:ͬ�������Ҳ�������
SVT_CONNECT_NUM_ERROR = 11              --��:�쳣�ļ������ӣ���:���ݿ������ж�
SVT_CREATE_ROLE_SIZE_INSERT_ERROR = 12  --��:�������������쳣����:�������ݴ����С��һ��
SVT_CREATE_ROLE_REPEAT_NAME = 13        --��:�����쳣�����ԣ���:��������
SVT_CREATE_ROLE_DBRET_ERROR = 14        --��:�����쳣�����ԣ���:�������ݷ���ʧ��
SVT_LOADING_ERROR_CANOT_COMPLETE = 15   --��:�޷��ҵ������������:�Ҳ����������
SVT_LOADING_ERROR_CANOT_INDEX = 16      --��:�޷��ҵ������������ã���:�Ҳ������ر�������
SVT_LOADING_ERROR_CANOT_TYPE = 17       --��:�޷��ҵ������������ͣ���:�Ҳ������ر�������
SVT_CREATE_TABLE_CONFIG_ERROR = 18      --��:���ݼ��ر��쳣����:������ֵȳ���
SVT_CREATE_NAME_CONFIG_ERROR = 19       --��:�����쳣����:ȡ���Ƿ�
SVT_LOADING_SELRET_ERROR = 20           --��:��¼�������������쳣����:BGA��̫��
SVT_LOAD_ROLE_SIZE_SELECT_ERROR = 21    --��:�������������쳣����:�������ݴ����С��һ��
SVT_CREATE_ROLE_STREAM_ERROR = 22       --��:�������ݸ����쳣����:�������ݴ����С��һ��
SVT_DBS_LOAD_FULL = 23                  --DBS���ؽ�ֹ��½
SVT_DBS_STRUCT_ERROR = 24               --���ݿ��ֶ���ɾ��
SVT_GAME_SCRIPT_DUMP = 25               --�籾����
SVT_ENTER_SCRIPT_LIMIT = 26             --�籾��������(��������̫�࣬��������)
SVT_OVER_SCRIPT_PAYLOAD = 27            --�籾�Ѵ�������ޣ����Ժ�����
SVT_CANOT_SCRIPT_ENTER_REPEAT = 28      --����ͬʱ���������籾
SVT_INIT_SCRIPT_FAIL = 29               --�籾��ʼ��ʧ��
SVT_CANOT_ENTER_DEL_SCRIPT = 30         --��Ҫ����ľ籾������
SVT_JWT_CHEAT_PLAYERID = 31             --�Ƿ����������˺�
SVT_JWT_CHEAT_SERVERNAME = 32           --ѡ�����ķ�������ָ������������
SVT_JWT_CHEAT_AREA = 33                 --ѡ�����ķ�������ָ����������
SVT_JWT_CHEAT_TIME = 34                 --��¼��֤ʱ���쳣
SVT_INVALID_TCPUSER_STATE = 35          --��¼��֤����״̬�쳣
SVT_INVALID_LOGIN_PLAYER = 36           --δ��⵽��ҵ�Ψһ��ʶ
SVT_INVALID_TOKEN_EMPTY = 37            --��¼��֤��ϢΪ��
SVT_INVALID_MAGIC_NUM = 38              --α���¼��֤Э��Լ��
SVT_INVALID_LOGIN_TRY_TIME = 39         --��¼Ƶ�ι��죬���Ժ���
SVT_INVALID_REPLACE_OVER_TIME = 40      --����Ƶ�ι��죬���Ժ���
SVT_DBS_SQL_BUSY = 41                   --DBServer SQL ���̫�࣬��������
SVT_SERVER_MAINTAIN = 44                --����������ά��״̬
SVT_GAME_DB_ERROR = 500                 --��Ϸ���ݿ��ѯ����
SVT_CHAR_NOT_EXIST = 800                --��Ϸ��ɫ��û����
SVT_VALIDATE_OK = 1000                  --��֤�ɹ�
SVT_REBUILD_CONNECT = 1001              --���ӻָ�
--to C++ enum [SeValidateType] Define END

--to C++ enum [SeReconResult] Define BEGIN
SRCR_SUCCESS = 0                        --��֤�ɹ�
SRCR_COMMON_ERROR = 1                   --ͨ�ô���
SRCR_PLAYER_NOT_EXIST = 2               --��Ҳ�����
SRCR_SESSION_ERROR = 3                  --�Ự����
SRCR_PLAYER_ONLINE = 4                  --�����������
SRCR_CACHE_PACK_DROP = 5                --������ж�ʧ
--to C++ enum [SeReconResult] Define END

--to C++ enum [SeCreateCharRet] Define BEGIN
CCR_CREATE_CHAR_OK = 0
CCR_NAME_EXIST = 1
CCR_HEROCARD_ERROR = 2
CCR_DB_ERROR = 3
--to C++ enum [SeCreateCharRet] Define END

--to C++ enum [SeValidEndRetType] Define BEGIN
SVERT_OK = 0
SVERT_TCPRELOAD = 1
SVERT_CREATE = 2
SVERT_RECONNECT = 3
SVERT_RELOGIN = 4
--to C++ enum [SeValidEndRetType] Define END

--to C++ enum [SeRaceLoadType] Define BEGIN
SRLT_DEFAULT = 0                        --Ĭ�ϱ�������
--to C++ enum [SeRaceLoadType] Define END

--to C++ enum [SeTownValidType] Define BEGIN
STVT_TOWN = 0
STVT_RECON = 1
--to C++ enum [SeTownValidType] Define END

--to C++ enum [SeRaceValidType] Define BEGIN
SRVT_RACE = 0
SRVT_RECON = 1
SRVT_VIEW = 2
SRVT_NONE = 3
--to C++ enum [SeRaceValidType] Define END

--to C++ enum [SePlayerInfoQueryType] Define BEGIN
SPQT_NULL = 0
SPQT_FRIEND_INFO = 1                    --��ѯ������Ϣ
SPQT_FRIEND_RMB_FLAG = 2                --��ѯ���ѳ�ֵ��Ϣ
SPQT_END = 3
--to C++ enum [SePlayerInfoQueryType] Define END

--to C++ enum [SePublicValueOprType] Define BEGIN
SPVOT_ASSIGN = 0                        --��ֵ
SPVOT_INC = 1                           --�ӷ�
SPVOT_UNSET = 2                         --ɾ���ֶ�
--to C++ enum [SePublicValueOprType] Define END

--to C++ enum [SeFriendDataTargetOprType] Define BEGIN
SFDTOT_PRIVATE = 0                      --�Լ���˽������
SFDTOT_SHARED = 1                       --����ѹ��������
SFDTOT_FRIENDPRIVATE = 2                --���ѵ�˽������
--to C++ enum [SeFriendDataTargetOprType] Define END

--to C++ enum [SeMailType] Define BEGIN
SMAT_NULL = 0
SMAT_GM = 1                             --GM�ʼ�
SMAT_SYSTEM = 2                         --ϵͳ�ʼ�
SMAT_TREASUREMAZE = 3                   --����ͼ�����ʼ�
SMAT_GIVE_ADVANCEPURCHASE = 4           --����ԤԼ�¿��ʼ�
SMAT_COMMIT_TREASUREEXP = 5             --�Ϲ��ٱ��龭��
SMAT_ARENA_BET = 6                      --��̨��Ѻע����
SMAT_ARENA_BET_RANK = 7                 --��̨��Ѻע���н���
SMAT_ARENA_BATTLE_WIN = 8               --��̨��ս����������
SMAT_DAY3SIGNIN_REWARD = 9              --����ǩ������
SMAT_SWITCHTREASUREMONEY_ENDMONTH = 10  --��ĩ��ҳ�����������齱��
SMAT_RANKLIST_REWARD = 11               --���а���
SMAT_HOODLECONTRRANKLIST_REWARD = 12    --ȫ��С�������н���
SMAT_GRAB_TITLE_REWARD = 13             --���ƺŽ���
SMAT_SHOPREWARDFAIL = 14                --����ʧ�ܷ���
SMAT_QQ_PRIVALIGEGIFT = 15              --QQ��Ȩ
SMAT_WX_PRIVALIGEGIFT = 16              --΢����Ȩ
SMAT_ZM_REWARD = 17                     --���ŶԾ����㽱��
SMAT_UNLOCK_CHALLENGE_ORDER_ORIGINAL_PRICE = 18--ԭ�ۿ�ͨ������
SMAT_WEEKEND_REWARD = 19                --ĳЩ��ֽ���
SMAT_EQUIP = 30                         --װ������
SMAT_LIMITSHOPBUY = 31                  --��ʱ�̵깺��
SMAT_GIVEFRIEND_TREASUREBOOK = 32       --���ͺ��Ѱٱ���
SMAT_ZM_CHAMPION_REWARD = 33            --���ŶԾ����ѫ��
SMAT_END = 34
--to C++ enum [SeMailType] Define END

--to C++ enum [SeMailFilterType] Define BEGIN
SMFT_CREATE_TIME = 0                    --������ʱ�����
SMFT_LEVEL = 1                          --���ȼ�
SMFT_ZONE = 2                           --������
SMFT_SERVER = 3                         --������
SMFT_END = 4
--to C++ enum [SeMailFilterType] Define END

--to C++ enum [SeMailStateType] Define BEGIN
SMST_ANY = -1                           --����
SMST_NEW = 0                            --δ��δ��
SMST_READ = 1                           --�Ѷ�δ��
SMST_RECEIVED = 2                       --δ������
SMST_READRECEIVED = 3                   --�Ѷ�����
--to C++ enum [SeMailStateType] Define END

--to C++ enum [SeMailReceiveReasonType] Define BEGIN
SMRRT_SUC = 0                           --�ɹ�
SMRRT_TABLE_CANT_FIND = 1               --����δ��д
SMRRT_READ_FAIL = 2                     --��ȡ����
SMRRT_SCRIPT_FAIL = 3                   --�����ھ籾����ȡ
--to C++ enum [SeMailReceiveReasonType] Define END

--to C++ enum [SeBabyState] Define BEGIN
SBS_NULL = 0                            --û��
SBS_CHECK = 1                           --��Ҫ�ж��ܷ����
SBS_WILL = 2                            --�¸��±ض�����
SBS_PREBORN = 3                         --����ǰ����
SBS_BORNED = 4                          --�ѳ���
--to C++ enum [SeBabyState] Define END

--to C++ enum [SeBabyTaskState] Define BEGIN
SBTS_UnStart = 0                        --δ����
SBTS_End = 1                            --���
--to C++ enum [SeBabyTaskState] Define END

--to C++ enum [SeModifyPlayerAppearanceType] Define BEGIN
SMPAT_NULL = 0
SMPAT_TITLE = 1                         --�ƺ�
SMPAT_PAINTING = 2                      --����
SMPAT_MODEL = 3                         --ģ��
SMPAT_BACKGROUND = 4                    --����ͼ
SMPAT_BGM = 5                           --BGM
SMPAT_POETRY = 6                        --ʫ��
SMPAT_NAME = 7                          --����
SMPAT_PEDESTAL = 8                      --��̨
SMPAT_SHOWROLE = 9                      --ƽ̨չʾ��ɫID
SMPAT_LOGINWORD = 10                    --��½��
SMPAT_HEADBOX = 11                      --ͷ���
SMPAT_CHATBOX = 12                      --�����
SMPAT_LANDLADY = 13                     --�ϰ���
SMPAT_END = 14                          --��ֹ��
--to C++ enum [SeModifyPlayerAppearanceType] Define END

--to C++ enum [SeSpeicalDataType] Define BEGIN
SSDT_NULL = 0
SSDT_LUCKYVALUE = 1
SSDT_DAILY_LIMIT_ACT_FLAG = 2           --���޶���־
SSDT_MONEY = 3                          --����
SSDT_RENAME_NUM = 4                     --��������
SSDT_OPEN_HOUSE = 5                     --�����ƹ�
SSDT_SCRIPT_TRANS_FLAG = 6              --�籾��ս���
SSDT_CREATE_SCRIPT_TIME = 7             --�����籾ʱ��
SSDT_DAILY_RESET = 8                    --�籾�����ñ��
SSDT_FINFIRSTSHARE = 9                  --�Ƿ�����״η�����
SSDT_MAXID_SYNC = 10                    --MAXID
SSDT_SERVER_OPEN_TIME = 11              --����ʱ��
SSDT_ITEM = 12                          --��Ʒ
SSDT_LIMITGIFTOVERTIME = 13             --��ʱ�̵����ʱ��
SSDT_PLATBUFF = 14                      --ƽ̨BUFF
SSDT_ACTIVITYSTATE = 15                 --�״̬
--to C++ enum [SeSpeicalDataType] Define END

--to C++ enum [SeGameCmdType] Define BEGIN
SGC_NULL = 0
SGC_CREATE_SCRIPT = 1                   --�����籾
SGC_LOAD_SCRIPT = 2                     --���ؾ籾
SGC_LOAD_MAXID = 3                      --���ظ���Manager�����ID
SGC_CARRY_PLAT_ITEM_INFO = 4            --����ƽ̨��Ʒ����
SGC_CARRY_PLAT_SHOP_INFO = 5            --����ƽ̨�̵�����
SGC_CARRY_PLAT_DYNAMIC_INFO = 6         --����ƽ̨��̬����
SGC_CARRY_SCRIPT_DIFF_INFO = 7          --����ѡ��籾�Ѷ�����
SGC_CARRY_ACHIEVE_REWARD_INFO = 8       --����ѡ��ɾ�����
SGC_CARRY_MERIDIANS_INFO = 9            --�����澭��������
SGC_CARRY_UNLOCK_INFO = 10              --�����������
SGC_CARRY_TREASUREBOOK_INFO = 11        --����ٱ�������
SGC_CARRY_DIFFDROPDATA_INFO = 12        --����ȫ������ֵ�����������
SGC_CARRY_SPECIALDATA_INFO = 13         --���������޸�ö������
SGC_CARRY_BABY_INFO = 14                --���뺢������
SGC_CARRY_CREATE_ROLE_BABY_INFO = 15    --���봴���õĺ�������
SGC_CARRY_WISH_INFO = 16                --������Ը����
SGC_CARRY_SCRIPT_SHOP_INFO = 17         --����籾�̵���������
SGC_CARRY_GRAB_TITLE_INFO = 18          --����籾���ƺ�����
SGC_CARRY_SAME_SCRIPT_PLAYER_INFO = 19  --����ͬ�籾�������
SGC_CARRY_FINISH = 30                   --�����������
SGC_CHANGE_CONFIG = 31                  --��̬����
SGC_LOAD_ROLE_INFOS = 32                --���ؽ�ɫ����
SGC_LOAD_MARTIALS = 33                  --������ѧ����
SGC_LOAD_ITEM_INFO = 34                 --������Ʒ
SGC_LOAD_SHOP_INFO = 35                 --�����̵�
SGC_LOAD_DYNAMICATTR_INFO = 36          --���ض�̬����
SGC_LOAD_CITY_INFO = 37                 --���س���
SGC_LOAD_MAP_INFO = 38                  --���ص�ͼ
SGC_LOAD_TASK_INFO = 39                 --��������
SGC_LOAD_COMMON_INFO = 40               --��������ͨ������
SGC_LOAD_GIFT_INFO = 41                 --�����츳����
SGC_LOAD_EVOLUTION_INFO = 42            --�����ݻ�����
SGC_LOAD_DROPCTRL_INFO = 43             --���ص����������
SGC_LOAD_WISH_INFO = 44                 --������Ը����
SGC_LOAD_MAZE_INFO = 45                 --�����Թ�����
SGC_LOAD_CLAN_INFO = 46                 --������������
SGC_LOAD_DRTIMER_INFO = 47              --���ض�ʱ������
SGC_LOAD_ADVLOOT_INFO = 48              --���ص�ͼ����������
SGC_LOAD_ACHIEVE_INFO = 49              --���سɾ�����
SGC_LOAD_FUNCTIONKVDATA_INFO = 50       --��������
SGC_LOAD_TAG_INFO = 51                  --���ر������
SGC_LOAD_BATTLE_INFO = 52               --���ر������
SGC_LOAD_SYSTEM = 53                    --��̬����
SGC_LOAD_FINALBATTLE = 54               --���ս
SGC_LOAD_NPCCONTACT_INFO = 55           --��ɫ�ø�
SGC_LOAD_SCRIPTARENA_INFO = 56          --�籾��̨
SGC_LOAD_FINISH = 80                    --�籾���ݼ������
SGC_SAVE_CHARINFO = 81                  --��ɫ��ɫ���Ա䶯
SGC_SAVE_ROLEINFO = 82                  --��ɫ��Ϣ�䶯
SGC_SAVE_MAPINFO = 83                   --��ͼ��Ϣ�䶯
SGC_SAVE_ITEMINFO = 84                  --��Ʒ�䶯
SGC_SAVE_SHOPINFO = 85                  --�̵�䶯
SGC_SAVE_MARTIALINFO = 86               --��ѧ�䶯
SGC_SAVE_CITYINFO = 87                  --�ݵ���Ϣ�䶯
SGC_SAVE_TASKINFO = 88                  --������Ϣ�䶯
SGC_SAVE_GIFTINFO = 89                  --�츳��Ϣ�䶯
SGC_SAVE_DYNAMICATTRINFO = 90           --��̬���Ա䶯
SGC_SAVE_WISHTASKINFO = 91              --��Ը��Ϣ�䶯
SGC_SAVE_EVOLUTIONINFO = 92             --NPC�ݻ���Ϣ�䶯
SGC_SAVE_CLANINFO = 93                  --������Ϣ�䶯
SGC_SAVE_TAGINFO = 94                   --��Ǳ䶯
SGC_SAVE_DROPCTRLINFO = 95              --�����������
SGC_SAVE_DRTIMERINFO = 96               --��ʱ���䶯
SGC_SAVE_ADVLOOTINFO = 97               --��ͼ�������䶯
SGC_SAVE_ACHIEVINFO = 98                --�ɾ���Ϣ�䶯
SGC_SAVE_FUNCTIONKVDATAINFO = 99        --��Ϣ�䶯
SGC_SAVE_MAZEINFO = 100                 --�Թ���Ϣ�䶯
SGC_SAVE_UNLOCKINFO = 101               --�����䶯
SGC_SAVE_OVERREPORT = 102               --��Ŀ��������
SGC_SAVE_BATTLE = 103                   --ս������
SGC_SAVE_SYSTEM = 104                   --��̬����
SGC_SAVE_REDKNIEF = 105                 --�൶������Ϣ
SGC_SAVE_TREASUREBOOK = 106             --�ٱ�����Ϣ
SGC_SAVE_BABY = 107                     --���˳�����Ϣ
SGC_SAVE_FINALBATTLEINFO = 108          --���ս��Ϣ
SGC_SAVE_PLATFORM = 109                 --ƽ̨֪ͨ��Ϣ
SGC_SAVE_FINALBATTLE = 110              --���ս
SGC_SAVE_NPCCONTACT_INFO = 111          --��ɫ��ϵ
SGC_SAVE_TLOG = 112                     --TLOG
SGC_SAVE_SCRIPTARENA_INFO = 113         --�籾��̨
SGC_SAVE_FINISH = 150                   --�������
SGC_CLIENT_CLICKMSG_BEGIN = 151         --�û��ϱ�ָ�ʼ,ע���ָ�������,�籾�ڵĺ;籾���,�籾�ڵ�Ҫ��SGC_CLIENT_SCRIPT_END֮ǰ������
SGC_CLICK_MAP = 152                     --�����ͼ����
SGC_CLICK_NPC = 153                     --NPC����
SGC_CLICK_NPC_INTERACT = 154            --���NPCѡ���е�ѡ��,������ԭ���Ľ�ɫ����
SGC_CLICK_MAZE = 155                    --����Թ�����
SGC_CLICK_ROLE_ADDATTRPOINT = 156       --��ɫ�ӵ�
SGC_CLICK_ROLE_CHOOSE_WISHREWARD = 157  --��ɫѡ����Ը����
SGC_CLICK_ROLE_MARTIAL_FORGET = 158     --��ɫ������ѧ
SGC_CLICK_EXCHANGE_SILVER = 159         --�һ�����
SGC_CLICK_ROLE_SHOP_OP = 160            --��ɫ�̵����
SGC_CLICK_ITEM_OP = 161                 --��ɫ��Ʒ����
SGC_CLICK_ROLE_INSECT_GET = 162         --��ɫץ��
SGC_CLICK_ROLE_INSECT_SWALLOW = 163     --��ɫ�Ƴ�����
SGC_CLICK_ROLE_INSECT_ATTACHPOISION = 164--��ɫ�Ƴ渽��
SGC_CLICK_ROLE_JOIN_CLAN = 165          --��ɫ��������
SGC_CLICK_AIINFO = 166                  --��ȡ��ɫAI����
SGC_CLICK_UPLOAD_AIINFO = 167           --���н�ɫAI����
SGC_CLICK_BATTLE_WHEEL_WAR_RESULT = 168 --����ս�������
SGC_CLICK_BATTLE_OPERATE_UNIT = 169     --ս��������λ
SGC_CLICK_BATTLE_AUTO = 170             --��ǰ��λ�Զ�ս��
SGC_CLICK_BATTLE_OBSERVE = 171          --�۲쵥λ
SGC_CLICK_BATTLE_GAME_END = 172         --ս��ֱ�ӽ���
SGC_CLICK_BATTLE_CALL_HELP = 173        -- ���и���
SGC_CLICK_BATTLE_RETURN_PREBATTLE = 174 --����ս��ǰ
SGC_CLICK_BATTLE_WIN = 175              --ս��ʤ��
SGC_CLICK_BATTLE_AGAIN = 176            --�ٴ���ս
SGC_CLICK_BATTLE_CHECK = 177            --ս�����
SGC_CLICK_BATTLE_GIVEUP = 178           --����ս��,�Ӷ�������Ŀ
SGC_CLICK_DESICIBATTLE_IN = 179         --���ս��ս
SGC_CLICK_RANDOM_ATTR = 180             --�����������
SGC_CLICK_CREATE_ROLE = 181             --���ȷ������
SGC_CLICK_CREATE_BABY = 182             --���ȷ������
SGC_CLICK_CHEAT = 183                   --����ָ��
SGC_CLICK_ROLE_RANDOM_GIFT = 184        --��ȡ����츳
SGC_CLICK_ROLE_ADD_GIFT = 185           --��ɫ����츳
SGC_CLICK_ROLE_DEL_GIFT = 186           --��ɫɾ���츳
SGC_CLICK_ROLE_RANDOM_WISHREWARDS = 187 --��ȡ�����Ը����
SGC_CLICK_UPDATE_EMBATTLE_ROLES = 188   --����������Ϣ
SGC_CLICK_NPC_INTERACT_OPER = 189       --NPC��������
SGC_CLICK_TRY_INTERACT_WITH_NPC = 190   --������NPC����
SGC_CLICK_ACHIEVEPOINT = 191            --��ȡ�ɾ͵�
SGC_CLICK_DIALOG = 192                  --�Ի��򷵻�
SGC_CLICK_CHOICE = 193                  --ѡ��ѡ��
SGC_CLICK_WEEKROUND_DIFF = 194          --��Ŀ�Ѷ�ѡ��
SGC_CLICK_CLAN_ENTER = 195              --ѡ���������
SGC_CLICK_CLAN_MARTIAL_LEARN = 196      --����ѧ��
SGC_CLICK_CLAN_MISSION_START = 197      --���ɺø�����
SGC_CLICK_SELECT_SUBMIT_ITEM = 198      --�ύ��Ʒ
SGC_CLICK_PICKUP_ADVLOOT = 199          --������
SGC_CLICK_INCOMPLETE_BOOK_BOX = 200     --�������ϻ
SGC_CLICK_CHANGE_EMBATTLE_MARTIAL = 201 --������ѧ����
SGC_CLICK_UNLOCK_ROLE = 202             --������ɫ
SGC_CLICK_UNLOCK_SKIN = 203             --����Ƥ��
SGC_CLICK_BAGCAPACITY_BUY = 204         --���򱳰�����
SGC_CLICK_TEMPBAG_MOVEBACK = 205        --��ʱ������Ʒ�ƻ�
SGC_CLICK_SET_TITLE = 206               --���óƺ�
SGC_CLICK_SET_SUBROLE = 207             --�����油
SGC_CLICK_BREAK_DISP_LIMIT = 208        --�ø�ͻ��
SGC_CLICK_WEEKROUND_GAME_OVER = 209     --ȷ����Ϸ����
SGC_CLICK_CONSULT_CLOSE = 210           --��̽���ر�
SGC_CLICK_ROLE_DISGUISE = 211           --�����ɫ����
SGC_CLICK_FINALBATTLE_ENTERCITY = 212   --���ս����ݵ�
SGC_CLICK_FINALBATTLE_QUITCITY = 213    --���ս�˳��ݵ�
SGC_CLICK_FINALBATTLE_OPENBOX = 214     --���ս�򿪾ݵ㱦��
SGC_CLICK_BABY_LEARN = 215              --�����ʦ
SGC_CLICK_ADD_CLAN_DELEGATION_TASK = 216--��������ί������
SGC_CLICK_ADD_CITY_DELEGATION_TASK = 217--���ӳ���ί������
SGC_CLICK_LEAVETEAM = 218               --�뿪����
SGC_CLICK_SELECT_ZHUAZHOU = 219         --ѡ��ץ�ܽ��
SGC_CLICK_START_CLAN_ELIMINATE = 220    --��ʼ�߹�����
SGC_CLICK_CHOOSE_TIGUAN = 221           --ѡ���߹�
SGC_CLICK_SET_EMBBATTLE_SUBROLE = 222   --����ս����Ա�油
SGC_CLICK_HIGHTOWER_EMBATTLE_OVER = 223 --ǧ������ս�������
SGC_CLICK_CLEAR_INTERACT_INFO = 224     --��ս�����Ϣ
SGC_CLICK_INQUIRY_CHOICE = 225          --�̲�ѡ��
SGC_CLICK_FINALBATTLE_ANTIJAMMA = 226   --���ս������ֱ������
SGC_CLICK_CHOOSE_NPCMASTER = 227        --�߹�ѡ����ѵ�����
SGC_CLICK_GETBABY_CLOSE = 228           --�ر���ͽ��ӽ���
SGC_CLICK_SCRIPT_ARENA_BATTLE_START = 229--��ʼ�籾��̨
SGC_CLICK_CLOSE_SCRIPT_ARENA = 230      --�رվ籾��̨
SGC_CLICK_LIMITSHOP_ACTION = 231        --��ʱ�̵���Ϊ
SGC_CLICK_ROLE_LEARN_SECRET_BOOK_MARTIAL = 232--��ɫѧϰ�ؼ���ѧ
SGC_CLICK_FORCE_WEEK_END = 233          --ǿ����Ŀ����
SGC_CLICK_ROLECHALLENGE_SELECTROLE = 234--�����ѡ���ɫ
SGC_CLICK_MARTIAL_STRONG = 235          --�����ѧ�ж�
SGC_CLICK_MAKEMARTIALSECRET = 236       --���������ѧ�ؼ�
SGC_CLICK_QUERY_RES_DROP_ACTIVITY_INFO = 237--�����ѯ��Դ������Ϣ
SGC_CLICK_EXCHANGE_COLLECT_ACTIVITY = 238--����һ��ռ������
SGC_CLICK_COMMON_EMBATTLE_RESULT = 239  --������Ͳ�����
SGC_CLICK_ROLE_FACE_OPERATE = 240       --�籾��������
SGC_CLICK_PICK_CUSTOM_ADV_LOOT = 241    --ʰȡ�Զ���ð�յ���
SGC_CLICK_MAZE_ENTRY = 242              --����Թ�����ȷ��
SGC_SAVE_NICKNAME = 243                 --���������ǳ�
SGC_SET_CLANBRANCHSTATE = 244           --����С����״̬
SGC_KILL_CLANBRANCH = 245               --ֱ�ӽ�ɢС����
SGC_CLIENT_CLICKMSG_END = 700           --�û��ϱ�ָ�����,clickָ��ɷŴ�֮��
SGC_SERVER_MSG_BEGIN = 701              --����������֪ͨ��Э��begin
SGC_SERVER_FRIENDOPENTREASURE = 702     --���ѿ�����
SGC_SERVER_MSG_END = 750                --����������֪ͨ��Э�����
SGC_DISPLAY_CMD = 751                   --ִ�б���ID
SGC_DISPLAY_BEGIN = 752                 --����������Ϣ��ʼ����
SGC_DISPLAY_GAMEDATA = 753              --�·���Ϸͨ������
SGC_DISPLAY_MAINROLEINFO = 754          --������Ϣ����
SGC_DISPLAY_TEAM_INFO = 755             --������Ϣ����
SGC_DISPLAY_MAIN_ROLE_NAME = 756        --�������Ƹ���
SGC_DISPLAY_ROLECREATE = 757            --ʵ����ɫ��������
SGC_DISPLAY_ROLEDELETE = 758            --ʵ����ɫɾ������
SGC_DISPLAY_ROLECOMMON = 759            --ʵ����ɫͨ������
SGC_DISPLAY_ROLE_FAVOR = 760            --ʵ����ɫϲ������
SGC_DISPLAY_ROLE_BRO = 761              --ʵ����ɫ��������
SGC_DISPLAY_ROLEATTRS = 762             --ʵ����ɫ��������
SGC_DISPLAY_ROLEITEMS = 763             --ʵ����ɫ��Ʒ����
SGC_DISPLAY_ROLEMARTIALS = 764          --ʵ����ɫ��ѧ����
SGC_DISPLAY_ROLEGIFTS = 765             --ʵ����ɫ�츳����
SGC_DISPLAY_ROLEWISHTASKS = 766         --ʵ����ɫ��Ը����
SGC_DISPLAY_NPC_UPDATE = 767            --NPC��ɫ��������
SGC_DISPLAY_NPC_DELETE = 768            --NPC��ɫɾ������
SGC_DISPLAY_EVOLUTION_DELETE = 769      --�ݻ�ɾ������
SGC_DISPLAY_EVOLUTION_UPDATE = 770      --�ݻ���������
SGC_DISPLAY_EVOLUTION_RECORDUPDATE = 771--�ݻ���¼����
SGC_DISPLAY_EVOLUTION_RECORDDELETE = 772--�ݻ���¼ɾ��
SGC_DISPLAY_MONTHEVOLUTION = 773        --�¶��ݻ�����
SGC_DISPLAY_CREATEMAINROLE = 774        --������Ϣ
SGC_DISPLAY_CREATEBABYROLE = 775        --������Ϣ
SGC_DISPLAY_DISPOSITION = 776           --���ºøж���Ϣ
SGC_DISPLAY_ITEMCREATE = 777            --��Ʒ��������
SGC_DISPLAY_ITEMDELETE = 778            --��Ʒɾ������
SGC_DISPLAY_ITEMUPDATE = 779            --��Ʒ��������
SGC_DISPLAY_UNLOCKUPDATE = 780          --������������
SGC_DISPLAY_SUBMITITEM_SELECT = 781     --ѡ���ύ��Ʒ
SGC_DISPLAY_MAP_ADVLOOT = 782           --������
SGC_DISPLAY_DRTIMER_UPDATE = 783        --��ʱ����������
SGC_DISPLAY_ITEM_REFORGE_RESULT = 784   --������Ʒ���Խ��
SGC_DISPLAY_MARTIALDELETE = 785         --��ѧɾ������
SGC_DISPLAY_MARTIALUPDATE = 786         --��ѧ��������
SGC_DISPLAY_SYSTEMINFO = 787            --��Ϸϵͳ��Ϣ
SGC_DISPLAY_DIALOG = 788                --���Խ׶�ʹ��,�Ի�ָ��
SGC_DISPLAY_SELECT = 789                --���Խ׶�ʹ��,ѡ��ָ��
SGC_DISPLAY_CITY_MOVE = 790             --���ͼ�ƶ���ָ������ָ��
SGC_DISPLAY_CITYDATA = 791              --������Ϣ�����·�
SGC_DISPLAY_MAPMOVE = 792               --���Խ׶�ʹ��,��ͼ�ƶ�ָ��
SGC_DISPLAY_MAP_UPDATE = 793            --��ͼ���ݸ���
SGC_DISPLAY_ROLE_RANDOM_GIFT = 794      --��ȡ����츳
SGC_DISPLAY_GIFTUPDATE = 795            --�츳����
SGC_DISPLAY_GIFTDELETE = 796            --�츳ɾ��
SGC_DISPLAY_ROLE_RANDOM_WISHREWARDS = 797--��ȡ�����Ը����
SGC_DISPLAY_ROLE_WISHREWRAD = 798       --��Ը����
SGC_DISPLAY_WISHTASKUPDATE = 799        --��Ը����
SGC_DISPLAY_WISHTASKDELETE = 800        --��Ըɾ��
SGC_DISPLAY_TAGUPDATE = 801             --��Ǹ���
SGC_DISPLAY_TAGDELETE = 802             --���ɾ��
SGC_DISPLAY_ACHIEVEUPDATE = 803         --�ɾ͸���
SGC_DISPLAY_ACHIEVEDELETE = 804         --�ɾ�ɾ��
SGC_DISPLAY_TASKADD = 805               --����һ������ʵ��
SGC_DISPLAY_TASKUPDATE = 806            --��������ʵ����Ϣ
SGC_DISPLAY_TASK_COMPLETE = 807         --��ʾ����������
SGC_DISPLAY_TASK_REMOVE = 808           --ɾ������ʵ��
SGC_DISPLAY_BUYITEM = 809               --��ʾ�Ѿ����������Ϣ
SGC_DISPLAY_SELLITEM = 810              --��ʾ�Ѿ�����������Ϣ
SGC_DISPLAY_SHOP_UPDATE = 811           --��Ʒ��Ϣ����
SGC_DISPLAY_SHOP_DELETE = 812           --��Ʒ��Ϣ���
SGC_DISPLAY_BATTLE_SHOW_EMBATTLE = 813  --����ս ��ʾ�������
SGC_DISPLAY_BATTLE_START = 814          --ս����ʼ
SGC_DISPLAY_BATTLE_CREATEUNIT = 815     --������λ��Ϣ
SGC_DISPLAY_BATTLE_UPDATECOMBO = 816    --����combo��Ϣ
SGC_DISPLAY_BATTLE_OBSERVEUNIT = 817    --�۲쵥λ��Ϣ
SGC_DISPLAY_BATTLE_UPDATEUNIT = 818     --���µ�λ��Ϣ
SGC_DISPLAY_BATTLE_UPDATEOPTUNIT = 819  --���µ�ǰ������λ
SGC_DISPLAY_BATTLE_LOG = 820            --ս����Ϣ��־
SGC_DISPLAY_UPDATE_TREASURE_BOX = 821   --���±�����Ϣ
SGC_DISPLAY_BATTLE_HURT_INFO = 822      --�����˺���Ϣ
SGC_DISPLAY_BATTLE_END = 823            --ս������
SGC_DISPLAY_BATTLE_AUTO = 824           --�Զ�ս��
SGC_DISPLAY_BATTLE_BUFFDESC = 825       --����buff������Ϣ
SGC_DISPLAY_BATTLE_UPDATEROUND = 826    --���±�׼�غ�
SGC_DISPLAY_LOGICDEBUGINFO = 827        --��Ϸ�߼���������
SGC_DISPLAY_NPC_INTERACT_RANDOM_ITEMS = 828--չʾNPC�������
SGC_DISPLAY_EXECUTE_PLOT = 829          --ִ�о���
SGC_DISPLAY_EXECUTE_CUSTOM_PLOT = 830   --ִ���Զ������
SGC_DISPLAY_UPDATE_EMBATTLE_ROLES_RET = 831--����������Ϣ�������
SGC_DISPLAY_INIT_EMBATTLE_ROLES = 832   --��ʼ��������Ϣ
SGC_DISPLAY_BATTLE_CHECK = 833          --ս�����
SGC_DISPLAY_NPC_INTERACT_GIVE_GIFT = 834--������
SGC_DISPLAY_INVITEABLE_UPDATE = 835     --�������
SGC_DISPLAY_TASKTAG_GET = 836           --��ȡ�����ǽ��
SGC_DISPLAY_TASKTAG_SET = 837           --���������ǽ��
SGC_DISPLAY_MAZE_UPDATE = 838           --�����Թ�����
SGC_DISPLAY_MAZE_CARD_UPDATE = 839      --�����Թ���Ƭ����
SGC_DISPLAY_MAZE_AREA_UPDATE = 840      --�����Թ���������
SGC_DISPLAY_MAZE_GRID_UPDATE = 841      --�����Թ����θ�����
SGC_DISPLAY_MAZE_UNLOCK_GRID_CHOICE = 842--�����Թ���ѡ�����
SGC_DISPLAY_MAZE_UNLOCK_GRID_SUCCESS = 843--�����Թ���ɹ�
SGC_DISPLAY_MAZE_MOVE = 844             --�Թ��ƶ�����
SGC_DISPLAY_MAZE_MOVE_TO_NEW_AREA = 845 --�Թ��ƶ�������������
SGC_DISPLAY_WEEKROUNDITEMOUT = 846      --��Ŀ����������Ʒ������ʾ
SGC_DISPLAY_WEEKROUNDITEMIN = 847       --��Ŀ������Ʒ
SGC_DISPLAY_DYNAMIC_ADV_LOOT_UPDATE = 848--��̬ð�յ������
SGC_DISPLAY_CLAN_INFO_UPDATE = 849      --������Ϣ����
SGC_DISPLAY_CLAN_MISSION_LETTER_INFO_UPDATE = 850--��������������Ϣ����
SGC_DISPLAY_ACHIEVEPOINT = 851          --���гɾ͵�
SGC_DISPLAY_INTERACT_DATE_UPDATE = 852  --����ʱ�����
SGC_DISPLAY_INTERACT_REFRESHTIMES_UPDATE = 853--ˢ�´�������
SGC_DISPLAY_ADD_INTERACT_OPTION = 854   --��������ѡ��
SGC_DISPLAY_REMOVE_INTERACT_OPTION = 855--�Ƴ�����ѡ��
SGC_DISPLAY_ADD_ROLE_SELECT_EVENT = 856 --����ѡ���ɫ�¼�
SGC_DISPLAY_REMOVE_ROLE_SELECT_EVENT = 857--�Ƴ�ѡ���ɫ�¼�
SGC_DISPLAY_INCOMPLETE_BOOK_UPDATE = 858--���²���ϻ����
SGC_DISPLAY_EMBATTLE_MARTIAL_UPDATE = 859--������ѧ����
SGC_DISPLAY_TEMPBAG_LIST = 860          --��ʱ��Ʒ�б����
SGC_DISPLAY_ENTER_CITY = 861            --���н������֪ͨ
SGC_DISPLAY_SHOW_FOREGROUND = 862       --��ʾǰ��֪ͨ
SGC_DISPLAY_UNLOCK_ROLE = 863           --������ɫ
SGC_DISPLAY_UNLOCK_SKIN = 864           --����Ƥ��
SGC_DISPLAY_NEW_TOAST = 865             --����Ƥ��
SGC_DISPLAY_WEEK_ROUND_END = 866        --��Ŀ��������
SGC_DISPLAY_CLEAR_INTERACT_STATE = 867  --֪ͨ�ͻ�����ս�ɫ����״̬
SGC_DISPLAY_TRIGGER_ADV_GIFT = 868      --�ѹ��츳����
SGC_DISPLAY_ROLE_TITLEID = 869          --�ƺ����
SGC_DISPLAY_DISPLAY_CUSTOM_PLOT = 870   --�Զ���Ի�
SGC_DISPLAY_DYNAMICS_TOAST = 871        --Toast
SGC_DISPLAY_SCRIPT_ROLE_TITLE = 872     --�籾�ڳƺ�
SGC_DISPLAY_BABYSTATE_UPDATE = 873      --ͽ����Ϣ����
SGC_UPDATE_RANKLIST = 874               --�������а�
SGC_DISPLAY_REDKNIFE_UPDATE = 875       --������Ϣ����
SGC_DISPLAY_REDKNIFE_DELETE = 876       --������Ϣɾ��
SGC_DISPLAY_UPDATE_UNLOCK_DISGUISE = 877--�����ѽ�������
SGC_DISPLAY_FINALBATTLE_UPDATEINFO = 878--���´��ս��Ϣ
SGC_DISPLAY_FINALBATTLE_UPDATECITY = 879--���´��ս�ݵ���Ϣ
SGC_DISPLAY_UPDATE_DELEGATION_STATE = 880--��������ί�н���״̬
SGC_DISPLAY_ClAN_ELIMINATE_SHOW = 881   --�߹���ʾ����
SGC_DISPLAY_SHOWDATA_END_RECORD = 882   --���չʾ���ݽ�����¼
SGC_DISPLAY_START_GUIDE = 883           --��������
SGC_DISPLAY_UNLEAVEABLE_UPDATE = 884    --���������Ϣ�ı�
SGC_DISPLAY_BATTLE_CALL_HELP = 885      --���и��ַ�����Ϣ
SGC_DISPLAY_UPDATE_CHOCIE_INFO = 886    --����ѡ����Ϣ
SGC_DISPLAY_CLEAR_CHOCIE_INFO = 887     --���ѡ����Ϣ
SGC_DISPLAY_PLAY_MAZE_ROLE_ANIM = 888   --�����Թ���ɫ����
SGC_DISPLAY_SHOW_MAZE_ROLE_BUBBLE = 889 --��ʾ�Թ���ɫ����
SGC_DISPLAY_MAZE_ENEMY_ESCAPE = 890     --�Թ�����ս������
SGC_DISPLAY_CLOSE_GIVE_GIFT = 891       --�����������
SGC_DISPLAY_HIGHTOWER_BASE_INFO = 892   --ǧ����������Ϣ
SGC_DISPLAY_HIGHTOWER_REST_ROLES = 893  --ǧ��������Ϣ��ɫ
SGC_DISPLAY_INTERACT_DUEL_ROLES = 894   --��������Ϣ
SGC_DISPLAY_INTERACT_INQUIRY = 895      --�̲���
SGC_DISPLAY_MAINROLEPETINFO = 896       --���ǳ�����Ϣ
SGC_DISPLAY_MAINROLENICKINFO = 897      --�����ǳ���Ϣ
SGC_DISPLAY_SHOW_CHOICE_WINDOW = 898    --��ʾѡ�����
SGC_DISPLAY_SCRIPT_ARENA_BATTLE_END = 899--�籾��̨ս������
SGC_DISPLAY_START_SCRIPT_ARENA = 900    --�籾��̨��ʼ
SGC_DISPLAY_CLOSE_SCRIPT_ARENA = 901    --�رվ籾��̨
SGC_DISPLAY_AIINFO = 902                --AI����
SGC_DISPLAY_MARTIALSTRONG = 903         --��ѧ�ж����
SGC_DISPLAY_MAKEMARTIALSECRET = 904     --��ѧ�հ���ʹ�ý��
SGC_DISPLAY_SHOW_CHOOSEROLE = 905       --��ʾѡ���ɫ����
SGC_DISPLAY_STARTSHARELIMITSHOP = 906   --��ʼ��ʱ�̵��������
SGC_DISPLAY_DIFFDROPINFO = 907          --����ֵ������Ϣ
SGC_DISPLAY_RESDROP_ACTIVITY = 908      --��ʾ��Դ����
SGC_DISPLAY_COLLECT_ACTIVITY_EXCHANGE_RES = 909--�ռ���һ����
SGC_DISPLAY_UPDATE_SAME_THREAD_PLAYER = 910--����ͬ�߳��������
SGC_DISPLAY_NOTICE_CLIENT_FIGHT_PLAYER = 911--֪ͨ�ͻ����д��������
SGC_DISPLAY_NOTICE_CLIENT_ADD_FRIEND = 912--֪ͨ�ͻ�����Ӻ���
SGC_DISPLAY_LEVELUP = 913               --������Ϣ
SGC_DISPLAY_CLEAR_ALL_CHOICE_INFO = 914 --������н���ѡ�������ѡ����Ϣ
SGC_DISPLAY_SHOW_COMMON_EMBATTLE = 915  --��ʾͨ�ò������
SGC_DISPLAY_UPDATE_WEEK_ROUND_DATA = 916--������Ŀͳ������
SGC_DISPLAY_CUSTOM_ADV_LOOT_UPDATE = 917--�Զ���ð�յ���״̬����
SGC_DISPLAY_AUTO_BATTLE_TEST_REPLAY = 918--�Զ�ս������¼��
SGC_SHOW_DIALOG = 919                   --��ʾ�Ի���
SGC_DISPLAY_ROLE_FACE_QUERY = 920       --�籾������ѯ����
SGC_DISPLAY_ROLE_FACE_RESULT = 921      --�籾������������
SGC_DISPLAY_CLAN_BRANCH_INFO = 922      --����С������Ϣ
SGC_DISPLAY_CLAN_BRANCH_RESULT = 923    --�����߹�С���ɽ��
SGC_DISPLAY_DISGUISE = 924              --��������״̬
SGC_DISPLAY_END = 925                   --����������Ϣ�������
SGC_END = 926                           --��Ϸָ�����
SGC_CMD_NUM = 927
--to C++ enum [SeGameCmdType] Define END

--to C++ enum [RoleAttrAddType] Define BEGIN
RAAT_BASE = 0                           --��������,���������ɳ�+�ӵ�����
RAAT_BASEPERCENT = 1                    --�����ٷֱ�,�����ڻ�������
RAAT_NORMAL = 2                         --��ͨ����,װ��+����+��ѧ+�츳+ѧ��+ʳ��+��Ը����+�������Ե�
RAAT_NORMALPERCENT = 3                  --��ͨ���԰ٷֱ�,һ������Ŀ,BUFF�ϼӳɶ���
RAAT_CONVERT = 4                        --ת������
RAAT_NUMS = 5                           --����
--to C++ enum [RoleAttrAddType] Define END

--to C++ enum [RoleAddAttrPointType] Define BEGIN
RAAPT_LIDAO = 0                         --����
RAAPT_TIZHI = 1                         --����
RAAPT_JINGLI = 2                        --����
RAAPT_NEIJIN = 3                        --�ھ�
RAAPT_LINGQIAO = 4                      --����
RAAPT_WUXING = 5                        --����
RAAPT_NUMS = 6                          --����
--to C++ enum [RoleAddAttrPointType] Define END

--to C++ enum [GetRoleItemType] Define BEGIN
GRI_NULL = 0                            --��Ч
GRI_BAG_ITEM = 1                        --����
GRI_EQUIP_ITEM = 2                      --װ��
GRI_ALL_ITEM = 3                        --ȫ��
GRI_NUMS = 4                            --����
--to C++ enum [GetRoleItemType] Define END

--to C++ enum [ClanEnterState] Define BEGIN
CES_NULL = 0                            --��Ч
CES_FIGHT = 1                           --����
CES_COIN = 2                            --ͭ��
CES_NUM = 3                             --����
--to C++ enum [ClanEnterState] Define END

--to C++ enum [NpcEvolutionType] Define BEGIN
NET_TYPE_UNKNOW = 0                     --δ֪
NET_NAME_ID = 1                         --��ʾ����ID ����1:��ʾ����, ����2:��, ����3:��
NET_ATTR = 2                            --���� ����1:��������,����2:����ֵ
NET_LEVEL = 3                           --�ȼ� ����1:�ȼ�,����2:����
NET_FRAGMENT = 4                        --��Ƭ�ȼ� ����1:��Ƭ����,����2:���ӵȼ�
NET_RANK = 5                            --Ʒ�� ����1:Ʒ��
NET_FAVORTYPE = 6                       --ϲ�� ����1:ϲ��
NET_ITEM_DEL = 7                        --(�ѷ���) ��Ʒ ����1:ID,����2:����
NET_EQUIP_DEL = 8                       --(�ѷ���)װ�� ����1:װ��TypeID, ����2:uID, ����3:0
NET_REMOVE_ITEM_TYPEID_DEL = 9          --(�ѷ���) ɾ������db��Ʒ
NET_ITEM_TYPEID_DEL = 10                --(�ѷ���) ��ƷTypeID ����1:TypeID, ����2:����
NET_EQUIP_TYPEID_DEL = 11               --(�ѷ���) װ��TypeID ����1:TypeID, ����2:0 ����3:0
NET_MARTIAL_TYPEID = 12                 --��ѧTypeID ����1:TypeID, ����2:�ȼ�, ����3:����
NET_GIFT_TYPEID = 13                    --�츳TypeID ����1:TypeID
NET_CLAN = 14                           --���� ����1:����TypeID
NET_WISHTASK = 15                       --��Ը���� ����1:����UID,����2:״̬ID
NET_INVITE_COND = 16                    --������� ����1 condition ID
NET_SHOP = 17                           --�̵� ����1:�̵�ID,����2:λ�ã�����3: ����ͭ����
NET_DOORKEEPER = 18                     --���ŵ���
NET_SUBMASTER = 19                      --������
NET_MAINMASTER = 20                     --������
NET_TEMPMAINMASTER = 21                 --����������
NET_DUEL_PROTECT = 22                   --���ܱ�����
NET_BEEN_DUELED = 23                    --��������
NET_CONSULT_MARTIAL_TIMES = 24          --��ѧ��� ����1:typeid,����2:����
NET_CONSULT_GIFT_TIMES = 25             --�츳��� ����1:typeid,����2:����
NET_STEEL_MARTIAL_TIMES = 26            --͵ѧ��ѧ ����1:typeid,����2:����
NET_STEEL_GIFT_TIMES = 27               --͵ѧ�츳 ����1:typeid,����2:����
NET_COMPARE_TIMES = 28                  --�д���� ����1: 0 ����2:����
NET_BEG_TIMES = 29                      --���ִ��� ����1: 0 ����2:����
NET_RANDOM_GIFT_TIMES = 30              --����츳���� ����1:0 ����2:����
NET_EVO_MAZE = 31                       --�ݻ����Թ���id ����1:�Թ�����id
NET_DISPOSITION_DES = 32                --��ϵ������ ����1:��ɫtypeid ����2: ����id
NET_TITLE = 33                          --�ƺ� ����1:�ƺ�
NET_BROANDSIS = 34                      --���� ����1:typeid
NET_MARRY = 35                          --��� ����1:typeid ����2:����1typeid ����3:����2typeid
NET_SUBROLE = 36                        --�油 ����1:roletypeid ���ǵ�����Ů����typeid��һ���ĵ��ǲ����油
NET_SP_BUFF = 37                        --buff ����1:��������
NET_CHEAT_MARRY = 38                    --��ƭ����ı�ʶ ����1:1
NET_BREAK_LIMIT = 39                    --�ø�ͻ�Ʊ�ʶ ����1:1 ��ʾ������ 2 ��ʶ�Ѿ����
NET_ROLEMODEL = 40                      --��ɫ��� ����1:RoleModel typeid
NET_ROLESEX = 41                        --��ɫ�Ա� ����1:RoleSex enum
NET_PRISION = 42                        --�η��ݻ� ����1:BuildID
NET_INQUIRY = 43                        --�̲��ݻ� ����1:�̲�״̬
NET_BINGHUOCANSHI = 44                  --�����ʬ���ݻ� ����1:��̬��ʱ��ID ����2:����ʱ�� ����3:��̬����ID
NET_NEXT_EVOLUTE = 45                   --�´�ִ���ݻ� ����1:ִ����ΪID ����2:ִ������ID
NET_PARENTS = 46                        --��ĸ ����1:����typeid ����2:ĸ��typeid
NET_STATUS = 47                         --��ɫ��� ����1:���
NET_CANTBATTLE = 48                     --�޷����� ����1:ԭ��
NET_ABSORBATTR = 49                     --��ǰ��ɫ�������� ����1:���ܲ��� ����2:�������� ����3:����ֵ
NET_ABSORBATTR_ITEM = 50                --���ܵ��������� ����1:��ȡ��ɫTypeID ����2:�������� ����3:����ֵ
NET_ELIMINATE_MASTER = 51               --�߹ݴ������� ����1:���ɣ�����һ����������Ψһ���ɣ�
NET_DISGUISE = 52                       --��ɫ������Ϊ ����1:�Ƿ��ݻ�
NET_DYNAMIC_BUSINESS = 53               --���������Ƿ�ˢ��
NET_NUMS = 54                           --����
--to C++ enum [NpcEvolutionType] Define END

--to C++ enum [LetterMissionReq] Define BEGIN
REQ_LV = 0                              --�ȼ�Ҫ��
REQ_GOODEVIL = 1                        --����Ҫ��
REQ_CLAN = 2                            --����Ҫ��
REQ_RANK = 3                            --Ʒ��Ҫ��
REQ_FAVOR = 4                           --ϲ��Ҫ��
REQ_NUMS = 5                            --����
--to C++ enum [LetterMissionReq] Define END

--to C++ enum [ClanMissionState] Define BEGIN
CMS_NOR = 0                             --����
CMS_REPORT = 1                          --������
CMS_END = 2                             --���
CMS_GIVEUP = 3                          --����
CMS_NUMS = 4                            --����
--to C++ enum [ClanMissionState] Define END

--to C++ enum [MainRoleInfoType] Define BEGIN
MRIT_NULL = 0                           --��Ч����
MRIT_NULL1 = 1                          --��Ч����1
MRIT_MAINROLEID = 2                     --����ID
MRIT_CURMAP = 3                         --���ǵ�ǰ������ͼ
MRIT_CUR_MAZE = 4                       --��ǰ�Թ�
MRIT_CUR_CITY = 5                       --��ǰ����
MRIT_MAINROLE_MODELID = 6               --ģ��ID
MRIT_BAG_ITEMNUM = 7                    --��������
MRIT_BUYBAG_FLAG = 8                    --���򱳰����
MRIT_ENHANCEGRADE_DAYCOUNT = 9          --ÿ��������Ʒ��������
MRIT_REFORGE_DAYCOUNT = 10              --ÿ��������Ʒ��������
MRIT_CURCOIN = 11                       --����ͭ��
MRIT_CUR_TITLE = 12                     --���Ǿ籾��ǰ�ƺ�
MRIT_SCRIPT_CARRY_ITEM_NUM = 13         --�籾������Ʒ����
MRIT_EXTRA_GOOD = 14                    --����øжȼӳ���
MRIT_EXTRA_MARITAL = 15                 --��ѧ�ӳɱ���
MRIT_EXTRA_ROLEEXP = 16                 --��ɫ����ӳɱ���
MRIT_EXTRA_ROLESELLITEM = 17            --�̵�����������
MRIT_ENMEY_DIFFUP = 18                  --������ֵ�ϸ�
MRIT_EQUIP_ATTRUP = 19                  --װ�������ϸ�
MRIT_DIFF = 20                          --�Ѷ�ϵ��
MRIT_MARTIALLVMAX = 21                  --��ѧ�ȼ�����
MRIT_ROLELEVELMAX = 22                  --��ɫ�ȼ�����
MRIT_DEFAULT_GOOD = 23                  --Ĭ�Ϻøж�
MRIT_BATTLE_TEAMNUMS = 24               --�����������
MRIT_MARTIAL_NUM_MAX = 25               --��ѧ��������
MRIT_GAME_STATE = 26                    --��Ϸ״̬,����֮ǰ���ö�ٺ�charscript���ж�Ӧö��ҲҪ����,���ߺ�ֻ���ڴ�֮�������룬��Ȼ�浵���ݻ��ҵ�,SePlayer::OnProcPlayerLoadFinish��rkRoleManager.add_mainroleinfos��ϢҲҪ���
MRIT_GOLD = 27                          --����Ԫ��
MRIT_SILVER = 28                        --��������
MRIT_FORGE_EXP = 29                     --����������
MRIT_REFORGE_EXP = 30                   --����������
MRIT_SAVE_FRAME_NUM = 31                --�籾�洢֡��
MRIT_WEEK_TOTALTIME = 32                --��Ŀ�ۼ�ʱ��
MRIT_MARTIAL_LOW_INCOMPLETETEXT = 33    --��ѧ�ͼ�����
MRIT_MARTIAL_MID_INCOMPLETETEXT = 34    --��ѧ�м�����
MRIT_MARTIAL_HIGH_INCOMPLETETEXT = 35   --��ѧ�߼�����
MRIT_IS_RMBPLAYER = 36                  --�Ƿ��Ǻ���
MRIT_HEAVENHAMMER = 37                  --�칤��
MRIT_REFINEDIRON = 38                   --����
MRIT_PERFECTPOWDER = 39                 --������
MRIT_MAINROLESEX = 40                   --�����Ա�
MRIT_LASTMAP = 41                       --�����ϸ�������ͼ
MRIT_LUCKEYVALUE = 42                   --����ֵ
MRIT_GIFTMAXNUMS = 43                   --�츳�������
MRIT_INTERACT_UNLOCK_FLAG = 44          --��������
MRIT_GREEN_EQUIP = 45                   --��ʼ��װ
MRIT_UNLOCK_HOUSE = 46                  --�����ƹ�
MRIT_NPC_MASTER_ENABLE_STATE = 47       --�������ֹ��ܿ���״̬
MRIT_USER_RENAME_TIMES = 48             --�������������
MRIT_LAST_POS_ROW = 49                  --��һ��λ����
MRIT_LAST_POS_COLUMN = 50               --��һ��λ����
MRIT_CLICK_ROW = 51                     --�����
MRIT_CLICK_COLUMN = 52                  --�����
MRIT_SCRIPT_TRANS_FLAG = 53             --�籾��ת���
MRIT_CHALLENGE_ORDER_TYPE = 54          --��ս������
MRIT_CREATR_ROLE_ID = 55                --���ǽ�ɫ��ԴID
MRIT_CREATE_SCRIPT_TIME = 56            --�籾����ʱ��
MRIT_WANGYOUCAO = 57                    --���ǲ�
MRIT_ALL_CITY_FAVOR = 58                --ȫ���Ǻøж�
MRIT_ALL_CLAN_FAVOR = 59                --ȫ���ɺøж�
MRIT_OWN_CLAN_FAVOR = 60                --�����ɺøж�
MRIT_REFRESHBALL = 61                   --ˢ����
MRIT_MAKESCERETBOKK = 62                --��ѧ�հ���
MRIT_RESDROPACTIVITY_VALUE1 = 63        --��Դ�����ʲ�ֵ1
MRIT_RESDROPACTIVITY_VALUE2 = 64        --��Դ�����ʲ�ֵ2
MRIT_RESDROPACTIVITY_VALUE3 = 65        --��Դ�����ʲ�ֵ3
MRIT_RESDROPACTIVITY_VALUE4 = 66        --��Դ�����ʲ�ֵ4
MRIT_RESDROPACTIVITY_VALUE5 = 67        --��Դ�����ʲ�ֵ5
MRIT_CUR_RESDROP_COLLECTACTIVITY = 68   --��Դ�����ռ��ID
MRIT_TREASUREEXCHANGE_VALUE1 = 69       --�ر��ʲ�ֵ1
MRIT_TREASUREEXCHANGE_VALUE2 = 70       --�ر��ʲ�ֵ2
MRIT_FESTIVAL_VALUE1 = 71               --���ջ�ʲ�ֵ1
MRIT_FESTIVAL_VALUE2 = 72               --���ջ�ʲ�ֵ2
MRIT_TONGLINGYU = 73                    --ͨ����
MRIT_PLAYEROPENED_TREASUREMAP = 74      --����Ѿ������Ĳر�ͼ����
MRIT_NUMS = 75                          --����
--to C++ enum [MainRoleInfoType] Define END

--to C++ enum [EnNoTimeOutMessageType] Define BEGIN
ENTMT_WordFilter = 1                    --��������֤��Ϣ
ENTMT_WordFilter_PlatReName = 2         --ƽ̨������������֤��Ϣ
--to C++ enum [EnNoTimeOutMessageType] Define END

--to C++ enum [SeScriptState] Define BEGIN
SSS_NULL = 0                            --��Чλ
SSS_ENTER = 1                           --ʹ��״̬
SSS_NUMS = 2                            --����
--to C++ enum [SeScriptState] Define END

--to C++ enum [GameState] Define BEGIN
GS_NULL = 0                             --��Чλ
GS_WENDA = 1                            --��ʼ�ʴ�
GS_CREATEROLE = 2                       --����״̬
GS_BIGMAP = 3                           --���ͼ״̬
GS_NORMALMAP = 4                        --��ͨ��ͼ״̬
GS_MAZE = 5                             --�Թ�״̬
GS_FINAL_BATTLE = 6                     --���ս
GS_WEEK_END = 7                         --������Ŀ
GS_NUMS = 8                             --����
--to C++ enum [GameState] Define END

--to C++ enum [UIState] Define BEGIN
US_NULL = 0                             --��Ч
US_SELECT = 1                           --ѡ��
US_WEEKITEMIN = 2                       --��Ŀ��Ʒ����
US_DIFF = 3                             --��Ŀ�Ѷ�ѡ��
US_SELECTITEM = 4                       --ѡ���ύ��Ʒ
US_SELECTCLAN = 5                       --ѡ�����ɽ���
US_CLANELIMINATE = 6                    --��������չʾ
US_REMOVESELECT = 7                     --�Ƴ�ѡ�����
US_SCRIPTARENA = 8                      --�籾��̨����
US_CLANELIMATE = 9                      --�߹ݲ������
US_CHOOSENPCUI = 10                     --ѡ����ѵ����Ž���
US_HIDE_MENU = 11                       --���ز˵�
US_CLANEBRANCHLIMINATE = 12             --С��������չʾ
US_NUMS = 13                            --����
--to C++ enum [UIState] Define END

--to C++ enum [SeMartialState] Define BEGIN
SMS_NULL = 0                            --��Чλ
SMS_EMBATTLE = 1                        --��ս
SMS_NUMS = 2                            --����
--to C++ enum [SeMartialState] Define END

--to C++ enum [SystemInfoType] Define BEGIN
SIT_NULL = 0                            --��Чλ
SIT_COMMON = 1                          --��ͨ����(���½����������ʾ��)
SIT_SYSTEM = 2                          --ϵͳ����
SIT_WORLD = 3                           --���繫��
SIT_TV = 4                              --����Ƶ��ӹ���
SIT_BUBBLE = 5                          --������ʾ
SIT_DIALOG = 6                          --������ʾ
NIT_NUMS = 7                            --����
--to C++ enum [SystemInfoType] Define END

--to C++ enum [InteractUnlockWay] Define BEGIN
IUW_NULL = 0                            --��Чλ
IUW_ONCE = 1                            --�籾��
IUW_FOREVER = 2                         --����
IUW_NUMS = 3                            --����
--to C++ enum [InteractUnlockWay] Define END

--to C++ enum [RoleEquipItemPos] Define BEGIN
REI_NULL = 0                            --��Чλ
REI_WEAPON = 1                          --����
REI_CLOTH = 2                           --�·�
REI_JEWELRY = 3                         --��Ʒ
REI_WING = 4                            --���
REI_THRONE = 5                          --����
REI_SHOE = 6                            --Ь��
REI_RAREBOOK = 7                        --�ؼ�
REI_HORSE = 8                           --����
REI_ANQI = 9                            --����
REI_MEDICAL = 10                        --ҽ��
REI_NUMS = 11                           --����
--to C++ enum [RoleEquipItemPos] Define END

--to C++ enum [SeItemRecycleType] Define BEGIN
SIRT_NULL = 0                           --��Чλ
SIRT_PLAT = 1                           --ƽ̨
SIRT_SCRIPT = 2                         --�籾
--to C++ enum [SeItemRecycleType] Define END

--to C++ enum [SeAchieveType] Define BEGIN
SAT_NULL = 0                            --��Ч
SAT_FINISH = 1                          --���
SAT_UNFINISH = 2                        --δ���
--to C++ enum [SeAchieveType] Define END

--to C++ enum [FinalBattleState] Define BEGIN
FBS_NULL = 0                            --δ����
FBS_RUNNING = 1                         --������
FBS_WIN = 2                             --ʤ��
FBS_LOST = 3                            --ʧ��
FBS_NORMALEND = 4                       --��ͨ���
--to C++ enum [FinalBattleState] Define END

--to C++ enum [ShowDataRecordType] Define BEGIN
SDRT_NULL = 0                           --��Ч
SDRT_GAMESTATE = 1                      --��Ϸ״̬
SDRT_ROLENAME = 2                       --��ɫ����
SDRT_ROLEMODEL = 3                      --��ɫ���
SDRT_UISTATE = 4                        --UI״̬
--to C++ enum [ShowDataRecordType] Define END

--to C++ enum [PlayerSimpleInfoOptType] Define BEGIN
PSIOT_NULL = 0                          --��Ч
PSIOT_AREA = 1                          --�·��ƹ����
PSIOT_LIST = 2                          --�·��б����
--to C++ enum [PlayerSimpleInfoOptType] Define END

--to C++ enum [RoleUpdateType] Define BEGIN
REUT_NULL = 0                           --��Ч
REUT_CREATE = 1                         --��ɫ����
REUT_DELETE = 2                         --��ɫɾ��
REUT_COMMON = 3                         --ͨ�����ԣ����Ƴƺŵ�
REUT_ATTR = 4                           --������ֵ��һ�����Ե�
REUT_ITEM = 5                           --��Ʒ
REUT_GIFT = 6                           --�츳
REUT_MARTIAL = 7                        --��ѧ
REUT_WISHTASK = 8                       --��Ը����
REUT_NUMS = 9                           --����
--to C++ enum [RoleUpdateType] Define END

--to C++ enum [FriendOprType] Define BEGIN
FROT_NULL = 0                           --��Ч
FROT_QUERY = 1                          --��ѯ
FROT_NUMS = 2                           --����
--to C++ enum [FriendOprType] Define END

--to C++ enum [SeQueryFriendAttriType] Define BEGIN
SQFAT_NULL = 0                          --��Ч
SQFAT_RMBFLAG = 1                       --������ѯ
--to C++ enum [SeQueryFriendAttriType] Define END

--to C++ enum [RoleAddMartialType] Define BEGIN
RAMT_NULL = 0                           --��Ч
RAMT_LEARN = 1                          --ͨ��ѧϰ
RAMT_NOW = 2                            --ֱ�����
RAMT_NUMS = 3                           --����
--to C++ enum [RoleAddMartialType] Define END

--to C++ enum [TaskProgressType] Define BEGIN
TPT_INIT = 0                            --��ʼ����
TPT_SUCCEED = 1                         --�����
TPT_FAILED = 2                          --��ʧ��
--to C++ enum [TaskProgressType] Define END

--to C++ enum [RoleBitField] Define BEGIN
RBF_TEAMMATES = 0
RBF_DEAD = 1
RBF_CANNOT_LEAVE = 2
RBF_ONCE_INTEAM = 3                     --�����ڶ�����
--to C++ enum [RoleBitField] Define END

--to C++ enum [RoleAddGiftType] Define BEGIN
RAGT_NULL = 0                           --����
RAGT_LEARN = 1                          --ѧϰ
RAGT_STEAL = 2                          --͵ѧ
RAGT_CONSULT = 3                        --���
RAGT_USEITEM = 4                        --����
RAGT_EQUIP = 5                          --װ��
RAGT_TASK = 6                           --����
RAGT_EVO = 7                            --�ݻ�
RAGT_EQUIP_ADV = 8                      --ð��
RAGT_WISH = 9                           --��Ը
RAGT_NUMS = 10                          --����
--to C++ enum [RoleAddGiftType] Define END

--to C++ enum [AddMartialType] Define BEGIN
AMT_NULL = 0                            --����
AMT_LEARN = 1                           --ѧϰ
AMT_STEAL = 2                           --͵ѧ
AMT_CONSULT = 3                         --���
AMT_USEITEM = 4                         --����
AMT_EQUIP = 5                           --װ��
AMT_TASK = 6                            --����
AMT_GIFT = 7                            --�츳
AMT_AOYI = 8                            --����
AMT_WISH = 9                            --��Ը
AMT_NUMS = 10                           --����
--to C++ enum [AddMartialType] Define END

--to C++ enum [RoleWishTaskType] Define BEGIN
RWTT_INVALID = 0                        --��Ч
RWTT_UNFINISH = 1                       --δ���
RWTT_FINISH = 2                         --���
RWTT_END = 3                            --����
--to C++ enum [RoleWishTaskType] Define END

--to C++ enum [SeRivakeTimeType] Define BEGIN
SRTT_YEAR = 0                           --��
SRTT_MONTH = 0                          --��
SRTT_DAY = 0                            --��
SRTT_HOUR = 0                           --��
--to C++ enum [SeRivakeTimeType] Define END

--to C++ enum [WeekDiffLimitType] Define BEGIN
WDLT_STORAGEITEM_MAX = 0                --������Ʒ����
WDLT_MARTIAL_NUM_MAX = 1                --��ѧ��������
WDLT_ROLE_LV_MAX = 2                    --��ɫ�ȼ�����
WDLT_EXTRA_ROLEEXP = 3                  --��ɫ����ӳ���
WDLT_BASE_ATTR_MAX = 4                  --������������
WDLT_JINGTONG_ATTR_MAX = 5              --��ͨ��������
WDLT_DAMAGE_MAX = 6                     --�����˺�����
WDLT_ENEMY_ATTR_ADD = 7                 --���������ϸ�
WDLT_EQUIP_LV_MAX = 8                   --װ���ȼ�����
WDLT_EXTRAMARTIAL_MAX = 9               --������ѧ��
WDLT_EXTRA_MARITAL = 10                 --��ѧ����ӳ���
WDLT_MARTIALLV_MAX = 11                 --��ѧ�ȼ�����
WDLT_HP_MAX = 12                        --�����������
WDLT_DEFENSE_MAX = 13                   --����������
WDLT_GIFTVALUE_MAX = 14                 --����츳����
WDLT_BATTLE_ROLE_MAX = 15               --��������ɫ����
WDLT_DEFAULT_GOOD_MAX = 16              --Ĭ�Ϻøж�
WDLT_EXTRA_GOOD = 17                    --�øжȼӳ���
WDLT_BAG_MAX = 18                       --��������
WDLT_EXTRA_ROLESELLITEM = 19            --�̵�����������
WDLT_MP_MAX = 20                        --�����������
WDLT_SPEED_MAX = 21                     --����ٶ�����
WDLT_MARTIAL_ATTACK_MAX = 22            --�����ѧ��������
WDLT_COIN_MAX = 23                      --���ͭ������
WDLT_NUMS = 24                          --����
--to C++ enum [WeekDiffLimitType] Define END

--to C++ enum [SeUnitCamp] Define BEGIN
SE_INVALID = 0                          --��Ч
SE_CAMPA = 1                            --��ӪA
SE_CAMPB = 2                            --��ӪB
SE_CAMPC = 3                            --��ӪC
--to C++ enum [SeUnitCamp] Define END

--to C++ enum [SeBattleEndFlag] Define BEGIN
SE_DEFEAT = 1                           --ʧ��
SE_VICTORY = 2                          --ʤ��
SE_SPECIALPLOT = 4                      --�������
SE_HIDEGAMEENDUI = 8                    --����ʾս����������
SE_ARENABATTLE = 16                     --��̨��ս��
SE_ONLYSHOWGIVEUP = 32                  --ֻ��ʾ���䰴ť���
SE_AUTOBATTLEAGAIN = 64                 --�Զ��ٴ�ս��
SE_ISLOAD = 128                         --�ɶ���������
--to C++ enum [SeBattleEndFlag] Define END

--to C++ enum [SeBattleMartialStateFlag] Define BEGIN
BMSF_USEABLE = 0                        --����ʹ��
BMSF_NO_MP = 1                          --��������
BMSF_DIZZY = 2                          --ѣ��
BMSF_FENG_YIN = 3                       --��ѧ����ӡ
BMSF_EMBATTLE = 4                       --��ѧ����
--to C++ enum [SeBattleMartialStateFlag] Define END

--to C++ enum [SeBattleEvaluateScoreType] Define BEGIN
SBEST_NO_DEATH = 0                      --��������
SBEST_ONE_ROUND_WIN = 1                 --һ�غ��ڻ�ʤ
SBEST_ONE_TIME_KILL = 2                 --һ��Nɱ
SBEST_BAO_JI = 3                        --����
SBEST_FAN_JI = 4                        --����
SBEST_SHI_PO = 5                        --ʶ��
SBEST_LIAN_JI = 6                       --����
SBEST_HE_JI = 7                         --�ϻ�
SBEST_LIAN_ZHAO = 8                     --����
SBEST_AO_YI = 9                         --��������
SBEST_JUE_ZHAO = 10                     --��������
SBEST_X_DEATH = 11                      --X������
SBEST_X_ROUND = 12                      --X�غ�
SBEST_CALL_HELP = 13                    --���и���
SBEST_NUM = 14                          --������
--to C++ enum [SeBattleEvaluateScoreType] Define END

--to C++ enum [SeRoleFaceOprType] Define BEGIN
SRFT_NULL = 0                           --��Чλ
SRFT_QUERY = 1                          --��ѯ
SRFT_UNLOCK_ROLEFACE = 2                --����������λ
SRFT_UNLOCK_MODEL = 3                   --��������ģ��
SRFT_UPLOAD = 4                         --�ϴ���������
SRFT_DELETE = 5                         --ɾ����������
--to C++ enum [SeRoleFaceOprType] Define END

--to C++ enum [SeRoleFaceOprTypeResult] Define BEGIN
SRFT_SUCCEED = 0                        --�ɹ�
SRFT_FAILED = 1                         --ʧ��
SRFT_DISABLED = 2                       --ϵͳ�ر�
SRFT_ROLE_NOT_EXIST = 3                 --������ɫ������
SRFT_ROLEFACE_NOT_EXIST = 4             --����������λ������
SRFT_ROLEFACE_NOT_SILVER = 5            --��������Ҫ����
SRFT_ROLEFACE_UNLOCKED = 6              --������λ�Ѿ�����
SRFT_ROLEFACE_NOT_ENOUGH = 7            --����������λ��������
SRFT_ROLEFACE_HIDE = 8                  --������ɫ��λ����
SRFT_ROLEFACE_LOCKED = 9                --������ɫ��λδ����
SRFT_ROLEFACE_SEXLIMIT = 10             --������ɫ��λ�Ա�ƥ��
SRFT_ROLEFACE_LIMIT = 11                --������ɫ��λ���λ�ó�������
SRFT_ROLEFACE_POSITION_ERR = 12         --������ɫ��λ��ƥ��
SRFT_ROLEFACE_MODEL_NOT_EXIST = 13      --����ģ�Ͳ�����
SRFT_ROLEFACE_MODEL_NOT_OPEN = 14       --����ģ��δ����
SRFT_ROLEFACE_MODEL_NOT_SILVER = 15     --��������ģ�Ͳ���Ҫ����
SRFT_ROLEFACE_MODEL_UNLOCKED = 16       --����ģ���Ѿ�����
SRFT_ROLEFACE_MODEL_NOT_ENOUGH = 17     --��������ģ����������
SRFT_ROLEFACE_MODEL_LOCKED = 18         --����ģ��δ����
SRFT_ROLEFACE_SEX_ERROR = 19            --�����Ա�ƥ��
--to C++ enum [SeRoleFaceOprTypeResult] Define END

--to C++ enum [BattleDamageExtraFlag] Define BEGIN
BDEF_NULL = 0                           --null
BDEF_CRIT = 1                           --����
BDEF_MISS = 2                           --Miss
BDEF_POZHAO = 3                         --����
BDEF_RECOVER = 4                        --�ָ�
BDEF_REBOUND = 5                        --�����˺�
BDEF_CEJI = 6                           --���
BDEF_BEIJI = 7                          --����
BDEF_FIGHT_BACK = 8                     --����
BDEF_DAMGE_CEILING = 9                  --�˺�����
BDEF_TANSHE = 10                        --����
--to C++ enum [BattleDamageExtraFlag] Define END

--to C++ enum [BattleTreasureBoxFlag] Define BEGIN
BTBF_ADD = 0                            --���
BTBF_DEL = 1                            --ɾ��
BTBF_OPEN = 2                           --��ȡ
--to C++ enum [BattleTreasureBoxFlag] Define END

--to C++ enum [BattleUseSkillExtraFlag] Define BEGIN
BUSEF_NULL = 1                          --null
BUSEF_LIAN_JI = 2                       --����
BUSEF_HE_JI = 4                         --�ϻ�
BUSEF_LIAN_ZHAO = 8                     --����
BUSEF_JUE_ZHAO = 16                     --����
BUSEF_AO_YI = 32                        --����
--to C++ enum [BattleUseSkillExtraFlag] Define END

--to C++ enum [SeBattleHurtBuffType] Define BEGIN
SBHBT_NULL = 0                          --��
SBHBT_NEW = 1                           --������buff
SBHBT_CHANGE_LAYER = 2                  --�ı������
SBHBT_DEL = 3                           --ɾ����
--to C++ enum [SeBattleHurtBuffType] Define END

--to C++ enum [RoleEmbattleType] Define BEGIN
INVALID = 0                             --��Ч
IN_TEAM = 1                             --����
IN_ASSIST = 2                           --����
IN_SUB = 3                              --�油
--to C++ enum [RoleEmbattleType] Define END

--to C++ enum [BattleSkillEventType] Define BEGIN
BSET_Null = 0                           --��
BSET_ZhuDong = 1                        --����
BSET_JueZhao = 2                        --����
BSET_HeJiQiDong = 3                     --�ϻ�����
BSET_Combo = 4                          --combo
BSET_LianJi = 5                         --����
BSET_FightBack = 6                      --����
BSET_BeiDong = 7                        --����
BSET_LianZhao = 8                       --����
BSET_ZhuiJia = 9                        --׷��
BSET_TouGuZhuiJia = 10                  --͸��׷��
BSET_BeiDong_WUYUE = 11                 --����_����
--to C++ enum [BattleSkillEventType] Define END

--to C++ enum [NPCInteractType] Define BEGIN
NPCIT_UNKNOW = 0                        --δ֪
NPCIT_GIFT = 1                          --����
NPCIT_WATCH = 2                         --�۲�
NPCIT_INVITE = 3                        --����
NPCIT_COMPARE = 4                       --�д�
NPCIT_BEG = 5                           --����
NPCIT_RANDOM_GIFT = 6                   --����츳
NPCIT_STEAL_CONSULT = 7                 --͵ѧ���������
NPCIT_STEAL = 8                         --͵ѧ������
NPCIT_STEAL_GIFT = 9                    --͵ѧ�츳
NPCIT_STEAL_MARTIAL = 10                --͵ѧ��ѧ
NPCIT_CONSULT = 11                      --���������
NPCIT_CONSULT_GIFT = 12                 --����츳
NPCIT_CONSULT_MARTIAL = 13              --�����ѧ
NPCIT_FIGHT = 14                        --����
NPCIT_SWORN = 15                        --����
NPCIT_MARRY = 16                        --���
NPCIT_REFRESH_CONSULT = 17              --ˢ����̴���
NPCIT_REFRESH_STEEL = 18                --ˢ��͵ѧ����
NPCIT_REFRESH_COMPARE = 19              --ˢ���д����
NPCIT_REFRESH_BEG = 20                  --ˢ�����ִ���
NPCIT_REFRESH_GIFT = 21                 --ˢ���츳����
NPCIT_REFRESH_WISHTASKREWARD = 22       --ˢ����Ը��������
NPCIT_REFRESH_CALLUP = 23               --ˢ�º��ٴ���
NPCIT_REFRESH_PUNISH = 24               --ˢ�³Ͷ����
NPCIT_CHANGE_SUB_ROLE = 25              --�����油
NPCIT_CALLUP = 26                       --����
NPCIT_PUNISH = 27                       --�Ͷ�
NPCIT_UNLOCK = 28                       --��������
NPCIT_INQUIRY = 29                      --�̲�
NPCIT_REFRESH_INQUIRY = 30              --ˢ���̲����
NPCIT_ABSORB = 31                       --����
NPCIT_NUMS = 32                         --������
--to C++ enum [NPCInteractType] Define END

--to C++ enum [ClanState] Define BEGIN
CLAN_CLOSE = 0                          --δ����
CLAN_WAIT_OPENED = 1                    --�ȴ�����
CLAN_WAIT_OPENED_NONPC = 2              --�ȴ���������ʼ��npc
CLAN_OPENED = 3                         --����
CLAN_DISAPPEAR = 4                      --��ʧ
CLAN_ALIGN = 5                          --����
CLAN_DRIVE_OUT = 6                      --����
CLAN_TREASURE_GOT = 7                   --��ȡ���ұ�
--to C++ enum [ClanState] Define END

--to C++ enum [SePlatTeamQueryType] Define BEGIN
SPTQT_NULL = 0                          --��Ч
SPTQT_PLAT = 1                          --ƽ̨����
SPTQT_SCRIPT = 2                        --�籾����
SPTQT_COMMON = 3                        --ͨ������
SPTQT_INSTROLE = 4                      --ʵ����ɫ
SPTQT_EMBATTLE = 5                      --������Ϣ
SPTQT_TEAM = 6                          --������Ϣ
SPTQT_OBSERVE_OTHER = 7                 --�۲�����
SPTQT_OBSERVE_ARENA = 8                 --��̨�۲�
--to C++ enum [SePlatTeamQueryType] Define END

--to C++ enum [SePlatTeamEmbattleInfo] Define BEGIN
SPTE_NULL = 0                           --��Ч
SPTE_SINGLE = 1                         --����
SPTE_TEAM = 2                           --���
--to C++ enum [SePlatTeamEmbattleInfo] Define END

--to C++ enum [SeArenaRequestType] Define BEGIN
ARENA_REQUEST_NULL = 0                  --��Ч
ARENA_REQUEST_MATCH = 1                 --������̨������
ARENA_REQUEST_BATTLE = 2                --�鿴ս������
ARENA_REQUEST_SIGNUP = 3                --��̨������
ARENA_REQUEST_UPDATE_PK_DATA = 4        --������̨��PK����
ARENA_REQUEST_VIEW_RECORD = 5           --�鿴¼��
ARENA_REQUEST_SIGNUP_MEMBER_NAME = 6    --�鿴��Χ�������
ARENA_REQUEST_VIEW_BET_RANK = 7         --�鿴Ѻעʤ����
ARENA_REQUEST_VIEW_OTHER_MEMBER_PK_DATA = 8--�鿴�������PK��Ϣ
ARENA_REQUEST_HISTORY_MATCH_DATA = 9    --�鿴��ʷ������Ϣ
ARENA_REQUEST_JOKE_MATCH_DATA = 10      --�鿴������������Ϣ
ARENA_REQUEST_CHAMPION_TIMES_DATA = 11  --�鿴���˱����ھ�������Ϣ
ARENA_REQUEST_HUASHANTOPMEMBER = 12     --�鿴��ɽ�۽���Χ����
--to C++ enum [SeArenaRequestType] Define END

--to C++ enum [SeArenaNoticeType] Define BEGIN
ARENA_NOTICE_NULL = 0                   --��Ч
ARENA_NOTICE_SIGNUP = 1                 --����
ARENA_NOTICE_BET = 2                    --Ѻע
ARENA_NOTICE_UPDATEPLATFORM = 3         --��������
--to C++ enum [SeArenaNoticeType] Define END

--to C++ enum [SeShopMallType] Define BEGIN
SSMT_NULL = 0                           --��
SSMT_PLATSHOP = 1                       --�ƹ��̵�
SSMT_TREASURESHOP = 2                   --�ٱ����̳�
SSMT_SCRIPTSHOP = 3                     --�籾�̵�
--to C++ enum [SeShopMallType] Define END

--to C++ enum [PlatShopMallRewardType] Define BEGIN
PSMRT_NULL = 0                          --��
PSMRT_MONEY = 1                         --�𶧴���
PSMRT_AD = 2                            --������
PSMRT_QUERY = 3                         --��ѯ��ǰ�����ܶ�
--to C++ enum [PlatShopMallRewardType] Define END

--to C++ enum [PlatShopMallRewardRetType] Define BEGIN
PSMRRT_SUCCESS = 0                      --���ͳɹ�
PSMRRT_FAILED = 1                       --����ʧ��
PSMRRT_CURREWARDVALUE = 2               --��ǰ�����ܶ�
--to C++ enum [PlatShopMallRewardRetType] Define END

--to C++ enum [PlatShopMallBuyRetType] Define BEGIN
PSMBRT_SUCCESS = 0                      --����ɹ�
PSMBRT_FAILED = 1                       --����ʧ��
--to C++ enum [PlatShopMallBuyRetType] Define END

--to C++ enum [PlatShopItemState] Define BEGIN
PSIS_NULL = 1                           --null
PSIS_LIMITBUYED = 2                     --�ѹ���
PSIS_UNLOCKCLAN = 4                     --����δ����
PSIS_TIMELIMIT = 8                      --��ʱ����
PSIS_MEDIANSLV = 16                     --�����ȼ�����
PSIS_ADDTOTALGOLD = 32                  --�ܳ�ֵ�𶧲���
--to C++ enum [PlatShopItemState] Define END

--to C++ enum [MoneyOprType] Define BEGIN
MOT_NULL = 0                            --null
MOT_SHOPBUY = 1                         --�̳ǹ���
MOT_GOLDEXCHANGE = 2                    --�𶧶һ�
MOT_TreasureBook_BRMB = 3               --��ͨ����
MOT_PresentGold = 4                     --���Ӵ���
MOT_BUYChallengeOrder = 5               --������ս��
MOT_BuyHorse = 6                        --����
MOT_BuyTreasureExp = 7                  --����ٱ��龭��
MOT_TreasureBook_AdvancePurchase = 8    --Ԥ���¿�
MOT_TreasureBook_GiveOther = 9          --������Ԥ���¿�
MOT_TreasureBook_GiveOtherFail = 10     --������Ԥ���¿�ʧ��
MOT_AddGold = 11                        --ʹ�õ������ӽ�
MOT_BuyDiscount_Coupon = 12             --�����Ż�ȯ
MOT_OpenMaxMeridiansLimitNum = 13       --�������鿪����
MOT_IdipCostGold = 14                   --idip�۳�����
MOT_SHOPLIMIT = 15                      --��ʱ�̵�
MOT_SHOPLIMITRECHARGE = 16              --��ʱ�̵��ֵ
MOT_SHOPGOLDREWARD = 17                 --�𶧴���
MOT_OPENFUND = 18                       --�������
MOT_Max = 19                            --��������
--to C++ enum [MoneyOprType] Define END

--to C++ enum [Click_Map_Type] Define BEGIN
CMT_NULL = 0                            --null
CMT_BUILDING = 1                        --�������
CMT_CITY = 2                            --�������
CMT_BACKRETURN = 3                      --���������һ������
CMT_TILE = 4                            --����µ�ͼ��
CMT_QUICKCITY = 5                       --����´��ͼ����
--to C++ enum [Click_Map_Type] Define END

--to C++ enum [Click_Maze_Type] Define BEGIN
CMAT_NULL = 0                           --null
CMAT_QUIT = 1                           --�˳��Թ�
CMAT_CLICKGRID = 2                      --����Թ���
CMAT_UNLOCKGRID = 3                     --��������Թ���
CMAT_GOAWAY = 4                         --����Ƶ�����
--to C++ enum [Click_Maze_Type] Define END

--to C++ enum [Click_Shop_Type] Define BEGIN
CST_NULL = 0                            --null
CST_BUY = 1                             --����
CST_SELL = 2                            --����
--to C++ enum [Click_Shop_Type] Define END

--to C++ enum [Click_Item_Type] Define BEGIN
CIT_NULL = 0                            --null
CIT_USE = 1                             --ʹ����Ʒ
CIT_USE_CONFIRM = 2                     --ʹ����Ʒ
CIT_MAKE = 3                            --������Ʒ
CIT_REFORGE = 4                         --������Ʒ
CIT_REFORGESAVE = 5                     --�������Ա���
CIT_REPAIR = 6                          --�޸���Ʒ
CIT_SMELT = 7                           --������Ʒ
CIT_UPGRADE = 8                         --������Ʒ
CIT_EQUIP = 9                           --װ����Ʒ
CIT_UNEQUIP = 10                        --ж����Ʒ
--to C++ enum [Click_Item_Type] Define END

--to C++ enum [DBLogServerQueryType] Define BEGIN
DBSQT_NULL = 0                          --null
DBSQT_SHOPREWARD = 1                    --��ѯ��������
--to C++ enum [DBLogServerQueryType] Define END

--to C++ enum [DBLogServerSendType] Define BEGIN
DBSST_NULL = 0                          --null
DBSST_ADD = 1                           --�ۼ�
--to C++ enum [DBLogServerSendType] Define END

--to C++ enum [DelegationTaskState] Define BEGIN
DTS_CLOSE = 0                           --δ����
DTS_OPEN = 1                            --����
--to C++ enum [DelegationTaskState] Define END

--to C++ enum [ChallengeOrderType] Define BEGIN
COT_FREE = 0                            --���
COT_MID = 1                             --�м�
COT_HIGH = 2                            --�߼�
COT_FIFTY_DISCOUNT = 3                  --50%�ۿ�
COT_TWENTYFIVE_DISCOUNT = 4             --25%�ۿ�
--to C++ enum [ChallengeOrderType] Define END

--to C++ enum [Day3SignInOptType] Define BEGIN
D3SOT_NULL = 0                          --��Ч
D3SOT_REQUEST = 1                       --��������
D3SOT_OPENWINDOW = 2                    --�򿪽���
D3SOT_BUYHORSE = 3                      --����
D3SOT_JOINTEAM = 4                      --���
D3SOT_WALK = 5                          --�߻�
--to C++ enum [Day3SignInOptType] Define END

--to C++ enum [Day3SignInStateType] Define BEGIN
D3SST_NULL = 0                          --��Ч
D3SST_FIRST = 1                         --��һ��
D3SST_SECOND_NORMAL = 2                 --�ڶ���δ봽�
D3SST_SECOND_FREE = 3                   --�ڶ��첻봽�
D3SST_THIRD = 4                         --�����쵽��N��
D3SST_MAX_DAY_NUM = 9                   --��ʱ�� �ӿ�����
D3SST_END = 10                          --�����
--to C++ enum [Day3SignInStateType] Define END

--to C++ enum [InquiryResultType] Define BEGIN
IRT_NULL = 0                            --��Ч
IRT_SAFE = 1                            --����
IRT_DOUBT = 2                           --����
IRT_GUILT = 3                           --����
--to C++ enum [InquiryResultType] Define END

--to C++ enum [InquiryChoiceType] Define BEGIN
ICT_NULL = 0                            --��Ч
ICT_FREE = 1                            --����һ��
ICT_CATCH = 2                           --���ù鰸
ICT_NOTHING = 3                         --ʲô������
--to C++ enum [InquiryChoiceType] Define END

--to C++ enum [AttrTypeMax] Define BEGIN
ATM_NULL = 0                            --��Ч
ATM_HITATKPER = 1                       --������
ATM_SHANBILV = 2                        --������
ATM_CRITATKPER = 3                      --������
ATM_BAOJIDIKANGLV = 4                   --�����ֿ���
ATM_CRITATKTIME = 5                     --�����˺�����
ATM_CONTINUATKPER = 6                   --������
ATM_LIANZHAOLV = 7                      --������
ATM_HEJILV = 8                          --�ϻ���
ATM_IGNOREDEFPER = 9                    --���ӷ�����
ATM_KANGLIANJILV = 10                   --��������
ATM_POZHAOLV = 11                       --������
ATM_FANJILV = 12                        --������
ATM_SUCKHP = 13                         --��Ѫ��
ATM_FANTANLV = 14                       --������
ATM_FANTANBEISHU = 15                   --��������
ATM_YUANHULV = 16                       --Ԯ����
ATM_JUEZHAOLV = 17                      --������
--to C++ enum [AttrTypeMax] Define END

--to C++ enum [TencentCreditScoreSceneLimitSystem] Define BEGIN
TCSSLS_NULL = 0                         --��Чλ
TCSSLS_WORLD_CHAT = 1                   --��������
TCSSLS_PRIVATE_CHAT = 2                 --˽��
TCSSLS_APPLY_FRIENDS = 3                --���������Ϊ����
TCSSLS_CHALLENGE = 4                    --�д�
TCSSLS_ARENA_SIGNUP = 5                 --������̨��
TCSSLS_RANKLIST = 6                     --�����а�
TCSSLS_NUM = 7                          --����
--to C++ enum [TencentCreditScoreSceneLimitSystem] Define END

--to C++ enum [SeEnKvType] Define BEGIN
EN_KV_NULL = 0
EN_KV_LIMIT_SHOP = 1
--to C++ enum [SeEnKvType] Define END

--to C++ enum [EnErrLimitShop] Define BEGIN
EErrLShop_NoShopData = 1001             --shop data not found
EErrLShop_NoShopGift = 1002             --shop gift not found
EErrLShop_ShopGiftSold = 1003           --shop gift sold out
EErrLShop_RefreshCoolDown = 1004        --shop refresh in cool down
EErrLShop_AlreadyShared = 1005          --already shared
EErrLShop_NoCoupon = 1006               --coupon not found
EErrLShop_CouponExpired = 1007          --coupon expired
EErrLShop_NeedGetYaZhu = 1008           --please get yazhu first
EErrLShop_YaZhuGameFinished = 1009      --yazhu game finished
EErrLShop_AlreadyFirstShare = 1010      --already finished first share
EErrLShop_ShortageBigGold = 1011        --shortage big-gold
EErrLShop_ShortageGold = 1012           --shortage gold
EErrLShop_CouponTooMany = 1013          --coupon too many
--to C++ enum [EnErrLimitShop] Define END

--to C++ enum [SeLimitShopOprType] Define BEGIN
EN_LIMIT_SHOP_GET = 0                   --��ȡ
EN_LIMIT_SHOP_REFLASH = 1               --ˢ��
EN_LIMIT_SHOP_REFLASHRET = 2            --ˢ�·���
EN_LIMIT_SHOP_BUY = 3                   --����
EN_LIMIT_SHOP_RECHARGE = 4              --��ֵ
EN_LIMIT_SHOP_FIRSTSHARE = 5            --�״η���
EN_LIMIT_SHOP_GETYAZHU = 6              --��ȡѺע
EN_LIMIT_SHOP_YAZHU = 7                 --Ѻע
EN_LIMIT_SHOP_YAZHU_RET = 8             --Ѻע����
EN_LIMIT_SHOP_SHARE = 9                 --��ͨ����
EN_LIMIT_SHOP_BUY_RET = 10              --���򷵻�
EN_LIMIT_SHOP_FIRSTSHAREOPR = 11        --�״η������
EN_LIMIT_SHOP_GETFIRSTSHARE = 12        --��ȡ�״η���
EN_LIMIT_SHOP_FINFIRSTSHARE_RET = 13    --����״η�����
--to C++ enum [SeLimitShopOprType] Define END

--to C++ enum [EnLimitType] Define BEGIN
EN_LIMIT_FREE = 0                       --���
EN_LIMIT_LV = 1                         --�弶
EN_LIMIT_LVUP = 2                       --����
EN_LIMIT_WU = 3                         --��ɫ��
EN_LIMIT_EQUIP = 4                      --�������
--to C++ enum [EnLimitType] Define END

--to C++ enum [NpcStaticItemState] Define BEGIN
NSIS_DEFAULT = 0                        --Ĭ�� 
NSIS_BAG = 1                            --������
NSIS_EQUIP = 2                          --װ����
NSIS_REMOVE = 3                         --���Ƴ�
NSIS_NUMS = 4                           --�������¼�ö����
--to C++ enum [NpcStaticItemState] Define END

--to C++ enum [EnZMRequest] Define BEGIN
EN_ZM_REQUEST_NULL = 0                  --��Ч
EN_ZM_REQUEST_Match = 1                 --ƥ�����ŶԾ�
EN_ZM_REQUEST_SelectClan = 2            --ѡ����
EN_ZM_REQUEST_SelectCard = 3            --ѡ��
EN_ZM_REQUEST_SelectEquip = 4           --ѡװ��
EN_ZM_REQUEST_SetBattleCard = 5         --����������
EN_ZM_REQUEST_EquipCard = 6             --����װ������
EN_ZM_REQUEST_ReflashClan = 7           --ˢ������
EN_ZM_REQUEST_ReflashCard = 8           --ˢ�¿���
EN_ZM_REQUEST_ReflashEquip = 9          --ˢ��װ��
EN_ZM_REQUEST_ViewRecord = 10           --�ۿ�¼��
EN_ZM_REQUEST_GetRoom = 11              --��ȡ����
EN_ZM_REQUEST_MatchEnd = 12             --ƥ��ɹ�
EN_ZM_REQUEST_MatchCancle = 13          --ƥ��ȡ��
EN_ZM_REQUEST_Die = 14                  --�ѱ���̭
EN_ZM_REQUEST_End = 15                  --ս������
EN_ZM_REQUEST_BuyShop = 16              --�̵깺��
EN_ZM_REQUEST_LeaveShop = 17            --�˳��̵�
EN_ZM_REQUEST_WatchOther = 18           --�۲��������
EN_ZM_REQUEST_UseClanSkill = 19         --ʹ�����ż���
--to C++ enum [EnZMRequest] Define END

--to C++ enum [EnZMError] Define BEGIN
EN_ZM_ERROR_None = 0                    --û�д���
EN_ZM_ERROR_InRoom = 1                  --�Ѽ������ŶԾ�,�޷��������������ŶԾ�
EN_ZM_ERROR_NoExist = 2                 --���ŶԾ����β�����
EN_ZM_ERROR_Playing = 3                 --���ŶԾ��Ѿ���ʼ,�޷�����
EN_ZM_ERROR_AlreadyClan = 4             --������ѡ
EN_ZM_ERROR_NoJoin = 5                  --û�μ�ƥ��
EN_ZM_ERROR_AlreadyJoin = 6             --��ƥ�����
EN_ZM_ERROR_Die = 7                     --�ѱ���̭�޷�����
EN_ZM_ERROR_RoomNoPlayer = 8            --���û�вμӱ�����
EN_ZM_ERROR_AlreadyOpt = 9              --�����Ѿ�ѡ��
EN_ZM_ERROR_Parmas = 10                 --��������
EN_ZM_ERROR_NoRoom = 11                 --�Ƿ�μ����ŶԾ�
EN_ZM_ERROR_NoShop = 12                 --�Ƿ����ŶԾ�����
EN_ZM_ERROR_InShop = 13                 --�����̵���㲻��ƥ��
EN_ZM_ERROR_NoGold = 14                 --�����̵��Ҳ���
EN_ZM_ERROR_NoRole = 15                 --�����̵겻���ڴ˽�ɫ��
EN_ZM_ERROR_AlreadyBuyRole = 16         --�����̵�˽�ɫ���ѹ���
EN_ZM_ERROR_NoTickets = 17              --���ŶԾ���Ʊ����
EN_ZM_ERROR_NoServer = 18               --����ͣ�������ܿ�ʼ�µ����ŶԾ�����
EN_ZM_ERROR_AlreadyUseClanSkill = 19    --�Ѿ�ʹ�����ż���
EN_ZM_ERROR_AlreadyNewFlag = 20         --�Ѳμӹ������ŶԾ���������
EN_ZM_ERROR_NotMatchTime = 21           --��ǰ����ƥ��ʱ����
--to C++ enum [EnZMError] Define END

--to C++ enum [EnZMNotice] Define BEGIN
EN_ZM_NOTICE_NULL = 0                   --��Ч
EN_ZM_NOTICE_Match = 1                  --ƥ��
EN_ZM_NOTICE_SelectClan = 2             --ѡ����
EN_ZM_NOTICE_SelectCard = 3             --ѡ��
EN_ZM_NOTICE_SelectEquip = 4            --ѡװ��
EN_ZM_NOTICE_AwardCard = 5              --����
EN_ZM_NOTICE_Pvp = 6                    --pvp
EN_ZM_NOTICE_Pve = 7                    --pve
EN_ZM_NOTICE_CardLvUp = 8               --����
EN_ZM_NOTICE_PanCha = 9                 --�̲鼼��
EN_ZM_NOTICE_Beg = 10                   --ؤ������
EN_ZM_NOTICE_DecomposeCard = 11         --���Ʒֽ�
EN_ZM_NOTICE_RoundEnd = 12              --��׶ν���
EN_ZM_NOTICE_RoleNum = 13               --32��ѡ������
EN_ZM_NOTICE_Gold = 10000               --���ű�
EN_ZM_NOTICE_RefreshTimes = 10001       --ˢ�´���
--to C++ enum [EnZMNotice] Define END

--to C++ enum [EnZMBegType] Define BEGIN
EN_ZM_BEG_NONE = 0                      --��
EN_ZM_BEG_SHENQI = 1                    --����
EN_ZM_BEG_REFRESHTIMES = 2              --ˢ�´���
EN_ZM_BEG_LETTAIBI = 3                  --��̨��
--to C++ enum [EnZMBegType] Define END

--to C++ enum [MartialStrongErrorCode] Define BEGIN
ENUM_MSEC_ERROR = 0                     --���ݴ���
ENUM_MSEC_FAILED = 1                    --ǿ��ʧ��
ENUM_MSEC_SUCCESS = 2                   --ǿ���ɹ�
ENUM_MSEC_SUPER_FAILED = 3              --����ʧ��
ENUM_MSEC_SUPER_STRONG = 100            --����
ENUM_MSEC_SUPER_CLEAR = 101             --��ħ
ENUM_MSEC_SUPER_CHANGE = 102            --����
ENUM_MSEC_SUPER_CHANGESTRONG = 103      --���컯��
ENUM_MSEC_NUMS = 104                    --�������¼�ö����
--to C++ enum [MartialStrongErrorCode] Define END

--to C++ enum [RoleCardType] Define BEGIN
RCT_ROLE = 0                            --��ɫ��
RCT_BOND = 1                            --�
--to C++ enum [RoleCardType] Define END

--to C++ enum [QueryResDropActivityType] Define BEGIN
EN_QUERY_RESDROP_ACTIVITY_NULL = 0      --��
EN_QUERY_RESDROP_ACTIVITY_COLLECT = 1   --�ռ��
EN_QUERY_RESDROP_ACTIVITY_MULTDROP = 2  --�౶����
EN_QUERY_RESDROP_ACTIVITY_NUM = 3       --�������¼�ö����
--to C++ enum [QueryResDropActivityType] Define END

--to C++ enum [DailyRewardState] Define BEGIN
DRS_NULL = 0                            --δ��ȡ
DRS_FREE = 1                            --��Ѱ�����ȡ
DRS_ALL = 2                             --��������ȡ
--to C++ enum [DailyRewardState] Define END

--to C++ enum [UnlockStoryNoticeType] Define BEGIN
USNT_NULL = 0                           --��
USNT_SUCCESS = 1                        --�ɹ�����
USNT_UNLOCKED = 2                       --�Ѿ������˵ľ籾
--to C++ enum [UnlockStoryNoticeType] Define END

--to C++ enum [SeActivityOprType] Define BEGIN
SAOT_NULL = 0                           --��
SAOT_EVENT = 1                          --�����¼�
SAOT_RECEIVE = 2                        --��ȡ����
SAOT_REQUEST = 3                        --����״̬
--to C++ enum [SeActivityOprType] Define END

--to C++ enum [SeActivityTriEventType] Define BEGIN
SATET_NULL = 0                          --��
SATET_SHAREFRIEND = 1                   --�������
SATET_SIGNIN = 2                        --ǩ��
SATET_REFRESH_EXCHANGE = 3              --�ر��-ˢ�¶һ���
SATET_TREASURE_EXCHANGE = 4             --�ر��-�һ�ָ����
SATET_PREEXP_RECEIVE = 5                --����-��ȡ���ֽ���
SATET_BACKFLOW_RECEIVE = 6              --�����-��ȡ��������
SATET_BACKFLOWPOINT_RECEIVE = 7         --�����-��ȡ���ֽ���
SATET_FUND_OPEN = 8                     --����ͨ
SATET_FUND_RECEIVE = 9                  --������ȡ����
SATET_FESTIVAL_SIGNIN = 10              --���ջǩ��
SATET_FESTIVAL_DIALYTASK_ACHIEVE = 11   --���ջ�ճ���������ȡ
SATET_FESTIVAL_LIVENESS_ACHIEVE = 12    --���ջ��Ծ�Ƚ�����ȡ
SATET_FESTIVAL_ASSET_CLEAN_CHECK = 13   --���նһ���ʲ�ֵ������
SATET_FESTIVAL_EXCHANGE = 14            --���ջ�һ�����
SATET_FESTIVAL_BUY_MALL = 15            --���ջ�̵깺��
--to C++ enum [SeActivityTriEventType] Define END

--to C++ enum [SeMonitorType] Define BEGIN
Monitor_Daily_JinMai = 0                --���ջ�þ����쳣
Monitor_Daily_Gold = 1                  --�������ѽ��쳣
Monitor_Daily_Slave = 2                 --�������������쳣
Monitor_Daily_Slave_Get = 3             --���ջ�ȡ�����쳣
Monitor_Daily_XiaoXiaKe = 4             --��������С�����쳣
Monitor_Daily_HongBao = 5               --���պ�������쳣
Monitor_Daily_TongGuanZiYou = 6         --����ͨ��ħ���籾�쳣
Monitor_Daily_TongGuanMoJun = 7         --����ͨ������ģʽ�쳣
Monitor_Daily_Chat = 8                  --���������쳣
--to C++ enum [SeMonitorType] Define END

--to C++ enum [ScriptOprRetType] Define BEGIN
SORT_FAILED = 0                         --����ʧ��
SORT_SUCCESS = 1                        --�����ɹ�
SORT_UNAVALIABLE = 2                    --�����籾ά����
SORT_DELSCRIPTLIMIT = 3                 --ÿ��ɾ���籾��������
--to C++ enum [ScriptOprRetType] Define END

--to C++ enum [PlayerCanOpenTreasureType] Define BEGIN
PCOTT_NULL = 0
PCOTT_YES = 1
PCOTT_NO = 2
--to C++ enum [PlayerCanOpenTreasureType] Define END

--to C++ enum [RolePetCardReqType] Define BEGIN
RPCRT_NULL = 0
RPCRT_ROLE_CARD = 1                     --��ɫ��
RPCRT_PET_CARD = 2                      --���￨
RPCRT_ROLE_BOND = 3                     --��ɫ�
RPCRT_ALL = 4                           --ȫ��
RPCRT_END = 5
--to C++ enum [RolePetCardReqType] Define END

--to C++ enum [RolePetCardOptType] Define BEGIN
RPCOT_NULL = 0
RPCOT_REQ_DATA = 1                      --��������
RPCOT_LEVEL_UP_ROLE_CARD = 2            --������ɫ��
RPCOT_LEVEL_UP_PET_CARD = 3             --�������￨
RPCOT_EVOLVE_PET_CARD = 4               --�������￨
RPCOT_SET_USE_PET_CARD = 5              --����ʹ���г��￨
RPCOT_SET_PLAT_SHOW_PET_CARD = 6        --����ƽ̨չʾ���￨
RPCOT_LEVEL_UP_ROLE_BOND = 7            --�����
RPCOT_END = 8
--to C++ enum [RolePetCardOptType] Define END

--to C++ enum [SystemModule] Define BEGIN
SM_NULL = 0
SM_ROLE_CARD = 1                        --��ɫ��
SM_PET_CARD = 2                         --���￨
SM_ITEM_ENHANCE = 3                     --��Ʒǿ��
SM_ITEM_SMELT = 4                       --��Ʒ����
SM_ITEM_RECAST = 5                      --��Ʒ����
SM_TREASURE_MAP = 6                     --�ر�ͼ
SM_ROLEFACE = 7                         --��������
SM_END = 8
--to C++ enum [SystemModule] Define END

--to C++ enum [SeSaveFileReqType] Define BEGIN
SSFRT_NEW_FILE = 0                      --�½��浵
SSFRT_SAVE_FILE = 1                     --���Ǵ浵
SSFRT_LOAD_FILE = 2                     --���ش浵
SSFRT_DELETE_FILE = 3                   --ɾ���浵
SSFRT_OPEN_SAVE_FILE = 4                --�Զ��浵����
--to C++ enum [SeSaveFileReqType] Define END


-- ��Ʒ
CommonTable_SeSimpleItem =
{
['uiItemID'] = 0,
['uiItemNum'] = 0,
}

-- ����ϴ��ı��ٱ�����Ϣ
CommonTable_SePlayerReportOprInfo =
{
['defReportPlayerID'] = 0,
['acReportType'] = 'nil',
['acReportDesc'] = 'nil',
['acReportContent'] = 'nil',
['dwReportScene'] = 0,
['dwReportEntrance'] = 1,
['acPicUrl'] = 'nil',
}

-- ��ȫ��־���ٱ�����Ϣ
CommonTable_SeTssSecReportPlayerInfo =
{
['dwPlatID'] = 0,
['dwAreaID'] = 0,
['dwZoneID'] = 0,
['acGoOpenID'] = 'nil',
['acVOpenID'] = 'nil',
['acIP'] = 'nil',
['dwRegTime'] = 0,
['acReportName'] = 'nil',
}

-- ��Ϸapp����
CommonTable_SeGameAppParam =
{
['acGameAppID_QQ'] = '1108328494',
['acGameAppID_WX'] = 'wx398d0e3e595d8823',
['acGameAppKey_QQ'] = 'Tu82FBUEZg6nZRzF',
['acGameAppKey_WX'] = '742607a8857a70f5be13e29796f337e1',
}

-- �ͻ����ϴ�����
CommonTable_SeClientMobilePhoneInfo =
{
['acClientVersion'] = 'NULL',
['acSystemSoftware'] = 'NULL',
['acSystemHardware'] = 'NULL',
['acTelecomOper'] = 'NULL',
['iScreenWidth'] = 0,
['iScreenHight'] = 0,
['acNetwork'] = 'NULL',
['acDensity'] = '0',
['iRegChannel'] = 0,
['acCpuHardware'] = 'NULL',
['iMemory'] = 0,
['acGLRender'] = 'NULL',
['acGLVersion'] = 'NULL',
['acDeviceId'] = 'NULL',
['acAndroidId'] = 'NULL',
['acRealIMEI'] = 'NULL',
['acIdfv'] = 'NULL',
['dwPlatID'] = 0,
['iTssSDKLen'] = 0,
['acSecTssSDK'] = 'nil',
['acVOpenID'] = 'nil',
['acGOpenId'] = 'nil',
['iClientLoginMethod'] = 0,
['iTencentPrivate'] = 0,
['acPF'] = 'nil',
['acPFKey'] = 'nil',
['acOpenKey'] = 'nil',
['isGuest'] = false,
['dwOS'] = 0,
['iLoginChannel'] = '0',
}

-- ����ϱ���Ϣ������
CommonTable_SePlayerOtherInfo =
{
['acPF'] = 'nil',
['acPFKey'] = 'nil',
['acOpenKey'] = 'nil',
['acUserIP'] = 'nil',
['acOpenId'] = 'nil',
['dwPlatID'] = 0,
['acServerAlias'] = 'nil',
['isGuest'] = false,
}

-- ������Ϣ
CommonTable_SeForBidInfo =
{
['eSeForBidType'] = SFBT_NULL,
['dwBegineTime'] = 0,
['iTime'] = 0,
['acReason'] = 'nil',
}

-- ������Ϣ
CommonTable_SeSystemSwitchInfo =
{
['bOpen'] = false,
['eSwitch'] = SGLST_NONE,
}

-- �ٱ��������Ϣ
CommonTable_TreasureBookBaseInfo =
{
['dwExp'] = 0,
['dwLvl'] = 0,
['dwMoney'] = 0,
['bRMBPlayer'] = false,
['bAdvancePurchase'] = false,
['bOpenRepeatTask'] = false,
['dwCurPeriods'] = 1,
['dwCurPeriodsWeek'] = 1,
['dwHeroCanGetExtraRewardTaskNum'] = 0,
['dwRMBCanGetExtraRewardTaskNum'] = 0,
['dwCurMaxGetDailySilverNum'] = 1,
['bOpenDailyGift'] = false,
['bEachDayGift'] = false,
['bEachWeekGift'] = false,
['dwProgressRewardFlag'] = 0,
['dwRMBProgressRewardFlag'] = 0,
['dwLvlRewardFlag1'] = 0,
['dwLvlRewardFlag2'] = 0,
['dwRMBLvlRewardFlag1'] = 0,
['dwRMBLvlRewardFlag2'] = 0,
['dwGivedFriendAdvanceNum'] = 0,
['dwPurchaseBookEndTime'] = 0,
['dwExtraGetRewardLvl'] = 0,
}

-- �ٱ���������Ϣ
CommonTable_SeTreasureBookTaskInfo =
{
['dwTaskTypeID'] = 0,
['dwProgress'] = 0,
['bReward'] = false,
['bCanReward'] = false,
['dwRepeatFinishNum'] = 0,
}

-- �ٱ����̳���Ϣ
CommonTable_SeTreasureBookMallInfo =
{
['dwItemTypeID'] = 0,
['dwExchangedNum'] = 0,
}

-- ����򿪽����Ϣ
CommonTable_SeGiftBagResultInfo =
{
['dwItemTypeID'] = 0,
['dwItemUID'] = 0,
['dwNum'] = 0,
}

-- ����۵�����ʾ��Ϣ
CommonTable_SeHoodleSlotDropTipsInfo =
{
['dwCurCDropBaseID'] = 0,
['dwCurDropItemID'] = 0,
['dwCurDropItemNum'] = 0,
['dwCurRewardItemID'] = 0,
['dwCurRewardItemNum'] = 0,
}

-- ��������������Ϣ
CommonTable_SeHoodleProgressInfo =
{
['eProgressType'] = SHBPT_NULL,
['dwCurProgress'] = 0,
['kProgressTip'] = nil,
['ePrivacyType'] = SHPCT_NULL,
['dwTotalHPNum'] = 0,
['dwPoolID'] = 0,
['bHide'] = false,
}

-- ����ۻ�����Ϣ
CommonTable_SeHoodleSlotInfo =
{
['dwSlotIndex'] = 0,
['kSlotTip'] = nil,
}

-- �����г齱������Ϣ
CommonTable_SeHoodlePlayerRetInfo =
{
['bSpecialHoodle'] = false,
['dwSpecialSlotProgress'] = 0,
['kHitSlotInfo'] = nil,
['akBoxInfo'] = nil,
}

-- ���齱�ػ�����Ϣ
CommonTable_SeHoodleLotteryBaseInfo =
{
['bOpen'] = false,
['dwSpecialSlotProgress'] = 0,
['dwCurPoolHoodleNum'] = 0,
['dwCurPoolFreeHoodleNum'] = 0,
['dwCurPoolDailyFreeHoodleNum'] = 0,
['dwAccForTenShootNum'] = 0,
['akProgressInfo'] = nil,
['akSlotInfo'] = nil,
}

-- �����и��˽�����Ϣ
CommonTable_SeHoodlePrivacyInfo =
{
['dwCurHoodlePrivacyID'] = 0,
['dwBeginTimeStamp'] = 0,
['dwEndTimeStamp'] = 0,
['dwTotalNormalNum'] = 0,
['dwCurResetNum'] = 0,
['bResetReFresh'] = false,
['akChivalrousInfo'] = nil,
}

-- ƽ̨��ҵļ�����Ϣ
CommonTable_SePlatPlayerSimpleInfo =
{
['defPlyID'] = 0,
['dwModelID'] = 0,
['acPlayerName'] = 'nil',
['bUnlockHouse'] = false,
['bRMBPlayer'] = false,
['charPicUrl'] = 'nil',
['dwTitleID'] = 0,
['dwPetID'] = 0,
['dwHeadBoxID'] = 0,
}

-- �籾����ҵ�������Ϣ
CommonTable_SePlayerInScriptData =
{
['dwPlayerID'] = 0,
['acPlayerName'] = 'nil',
['dwSex'] = 0,
['dwWeekRoundTotalNum'] = 0,
['dwALiveDays'] = 0,
['bUnlockHouse'] = false,
['dwAchievePoint'] = 0,
['dwMeridiansLvl'] = 0,
['dwCreateTime'] = 0,
['dwLastLogoutTime'] = 0,
['dwChallengeWinTimes'] = 0,
['bRMBPlayer'] = false,
['acOpenID'] = 'nil',
['acVOpenID'] = 'nil',
['acIP'] = 'nil',
['dwHoodleScore'] = 0,
['dwNormalHighTowerMaxNum'] = 0,
['dwBloodHighTowerMaxNum'] = 0,
['dwRegimentHighTowerMaxNum'] = 0,
['dwTitleID'] = 0,
['dwPaintingID'] = 0,
['dwModelID'] = 0,
['charPicUrl'] = 'nil',
['dwBackGroundID'] = 0,
['dwBGMID'] = 0,
['dwPoetryID'] = 0,
['dwPedestalID'] = 0,
['dwShowRoleID'] = 0,
['dwShowPetID'] = 0,
['dwLoginWordID'] = 0,
['dwHeadBoxID'] = 0,
}

-- ������Ϣ�ṹ
CommonTable_SeClanCollectionInfo =
{
['dwType'] = 0,
['dwNum'] = 0,
}

-- �澭�����������·��ṹ
CommonTable_SeMeridiansInfo =
{
['dwMeridianID'] = 0,
['dwAcupointID'] = 0,
['dwLevel'] = 0,
}

-- �𶧲���
CommonTable_SeGoldOprParam =
{
['defPlayerID'] = 0,
['eOprType'] = MOT_NULL,
['dwMoneyValue'] = 0,
['iParam1'] = 0,
['iParam2'] = 0,
['iParam3'] = 0,
['iParam4'] = 0,
['acBillNo'] = 'nil',
['acJson'] = 'nil',
['sysInfo'] = nil,
}

-- �𶧲�������
CommonTable_SeGoldOprRetParam =
{
['defPlayerID'] = 0,
['eOPType'] = MOT_NULL,
['iNowValue'] = 0,
['iCostValue'] = 0,
['iSuccess'] = 0,
['iParam1'] = 0,
['iParam2'] = 0,
['iParam3'] = 0,
['iParam4'] = 0,
['acJson'] = 'nil',
['acBillNo'] = 'nil',
['isDebug'] = false,
}

-- �𶧲�ѯ����
CommonTable_SeQueryGoldRetParam =
{
['defPlayerID'] = 0,
['iCurGold'] = 0,
['iAmtGold'] = 0,
['iCostGold'] = 0,
['iPresentGold'] = 0,
['iLeftPresentGold'] = 0,
['isDebug'] = false,
['ret'] = 0,
}

-- ˽����Ϣ
CommonTable_SePrivateTalkInfo =
{
['defPlyID'] = 0,
['acSessionID'] = 'nil',
['acOpenID'] = 'nil',
['acVOpenID'] = 'nil',
}

CommonTable_SePtlNetAddr =
{
['acHost'] = 'nil',
['acIP'] = 'nil',
['iPort'] = 0,
}

-- �汾���
CommonTable_SeCheckVersion =
{
['byMain'] = 1,
['bySub1'] = 0,
['bySub2'] = 0,
['bySub3'] = 23,
}

CommonTable_SePublicValuePair =
{
['acName'] = 'nil',
['iValue'] = 0,
['eOprType'] = SPVOT_INC,
}

CommonTable_SeFriendShareData =
{
['defFriendID'] = 0,
['iValue'] = 0,
['acName'] = 'nil',
}

-- �ʼ���ȡ���
CommonTable_SeMailReceiveReason =
{
['dwItemID'] = 0,
['dwItemNum'] = 0,
['eReason'] = SMRRT_SUC,
}

-- �ʼ���ȡ����
CommonTable_SeMailReceiveResult =
{
['bOpr'] = false,
['dwlMailID'] = 0,
['iNum'] = 0,
['akRetReason'] = nil,
}

-- �ʼ�����
CommonTable_SeMailFilter =
{
['eMailType'] = SMFT_END,
['acMin'] = 'nil',
['acMax'] = 'nil',
}

-- �ʼ���Ʒ
CommonTable_SeMailItem =
{
['dwItemID'] = 0,
['dwItemNum'] = 0,
}

-- �ʼ���Ϣ
CommonTable_SeSimpleMailInfo =
{
['defFromID'] = 0,
['dwlMailID'] = 0,
['eMailType'] = SMAT_NULL,
['dwlMailTime'] = 0,
['akAttachItem'] = nil,
}

-- �ʼ���Ϣ
CommonTable_SeMailInfo =
{
['dwlMailID'] = 0,
['dwlMailTime'] = 0,
['acUserID'] = 'nil',
['acReceiver'] = 'nil',
['acTitle'] = 'nil',
['acContent'] = 'nil',
['eMailType'] = SMAT_NULL,
['akAttachItem'] = nil,
}

-- GM�ʼ���Ϣ
CommonTable_SeGMMailInfo =
{
['acArriveTime'] = 'nil',
['kMailInfo'] = nil,
['iFilterNum'] = 0,
['akMailFilter'] = nil,
}

-- ��������
CommonTable_SeUnlockInfo =
{
['dwTypeID'] = 0,
['dwParam'] = 0,
}

-- ����ϻ����
CommonTable_SeInCompleteBookRecord =
{
['dwTypeID'] = 0,
['dwDreamLandTime'] = 0,
['dwArriveMaxLvl'] = 0,
['dwAddInCompleteBookNum'] = 0,
['dwAddInCompleteTextNum'] = 0,
}

-- ������ѧ
CommonTable_SeEmBattleMartialInfo =
{
['dwUID'] = 0,
['dwTypeID'] = 0,
['dwIndex'] = 0,
}

-- ������������
CommonTable_SeCarrySpecialData =
{
['eType'] = nil,
['iNum1'] = 0,
['iNum2'] = 0,
['iNum3'] = false,
}

-- ѡ��ѡ��ָ�����ʹ��
CommonTable_SeGameCmd_SelectOption_Content =
{
['acContent'] = 'nil',
}

CommonTable_SePlayerScriptInfo =
{
['dwScriptID'] = 0,
['dwScriptTime'] = 0,
['acMainRoleName'] = 'nil',
['dwDreamLandTime'] = 0,
['eStateType'] = SSS_NULL,
['dwUnlockMaxDiff'] = 0,
['dwWeekRoundNum'] = 0,
['dwScriptLucyValue'] = 0,
['bGotFirstReward'] = false,
}

-- ֪ͨ�ɾ�����
CommonTable_NoticeUnlockAchieveInfo =
{
['uiAchieveID'] = 0,
['iCurNum'] = 0,
}

-- �ɾͼ�¼����
CommonTable_AchieveSaveData =
{
['uiAchieveID'] = 0,
['iValue'] = 0,
['iFetchReward'] = 0,
}

-- ȫ���Ѷȵ������
CommonTable_DiffDropData =
{
['uiTypeID'] = 0,
['uiAccumulateTime'] = 0,
['uiRoundFinish'] = 0,
}

-- С���Ͳ�������
CommonTable_SeHoodlePlayer =
{
['defPlayerId'] = 0,
['acPlayerName'] = 'nil',
['uiPrecessValue'] = 0,
['dwServerID'] = 0,
}

-- ȫ��С������Ϣ
CommonTable_SeHoodLeLottery =
{
['uiOpenId'] = 0,
['uiTurns'] = 0,
['uiTotal'] = 0,
['uiNeedTotal'] = 0,
['uiBeginTime'] = 0,
['bResult'] = false,
['bOpen'] = false,
['bUseUp'] = false,
['uiPlayerNum'] = 0,
['akHoodlePlayer'] = nil,
['uiPersonalNum'] = 0,
['akPersonalProc'] = nil,
}

-- ȫ��С������ȡ��¼
CommonTable_SeHoodLeRecord =
{
['uiRecordTime'] = 0,
['defPlayerId'] = 0,
['uiItemId'] = 0,
['acPlayerName'] = 'nil',
['bMaxCont'] = false,
}

-- ȫ��С��������
CommonTable_SeHoodLePublicConfig =
{
['uiTotal'] = 0,
['iPlayerWeight'] = 0,
['uiBoundary'] = 0,
['iDayStartAuto'] = 0,
['iDayFinishAuto'] = 0,
['iNightStartAuto'] = 0,
['iNightFinishAuto'] = 0,
['acDaytimeDefine'] = 'nil',
}

-- ȫ��С���͵�ǰ���Ʒ��Ϣ
CommonTable_SeHoodLePublicItemInfo =
{
['uiItemID'] = 0,
['uiCurNum'] = 0,
['uiTotalNum'] = 0,
['uiShowTotalNum'] = 0,
['bTopReward'] = false,
}

-- ȫ��С���Ͷһ�����
CommonTable_SeHoodLeExChageData =
{
['uiItemId'] = 0,
['uiPrice'] = 0,
}

-- ȫ��С����������Ϣ
CommonTable_SeHoodLePublicData =
{
['uiBeginTime'] = 0,
['uiEndTime'] = 0,
['acResource'] = 'nil',
['iNum'] = 0,
['akAllItem'] = nil,
['iNum2'] = 0,
['akExchange'] = nil,
['iNum3'] = 0,
['akShowItem'] = nil,
}

-- GS���������Ϣ����
CommonTable_SeGsCachePlayerInfoConfig =
{
['bCacheSePlayerInfo'] = 0,
['iCacheSePlayerInfoNum'] = 0,
['iCacheSePlayerInfoTime'] = 0,
}

-- GS���ػ��������Ϣ��ִ�в���ʱ����Ҫת������Ϣ
CommonTable_SeRetPlayerInfoOptData =
{
['eOptType'] = PSIOT_NULL,
['iCachePageIndex'] = 0,
['iCachePageStartIndexOffset'] = 0,
['iGetCount'] = 0,
}

-- ���ͼ�¼
CommonTable_SeRewardRecord =
{
['defPlayerId'] = 0,
['acPlayerName'] = 'nil',
['iRewardValue'] = 0,
}

-- ����
CommonTable_RoleAttrData =
{
['uiAttrUID'] = 0,
['uiType'] = 0,
['iBaseValue'] = 0,
['iExtraValue'] = 0,
['uiRecastType'] = 0,
}

-- ����
CommonTable_SeAdvLoot =
{
['uiID'] = 0,
['uiSiteType'] = 0,
['uiSiteID'] = 0,
['uiAdvLootID'] = 0,
['uiAdvLootType'] = 0,
['uiNum'] = 0,
}

-- ʰȡð�յ�����������
CommonTable_PickUpAdvLootData =
{
['uiSite'] = 0,
['uiMID'] = 0,
['uiAreaID'] = 0,
['uiAdvLootID'] = 0,
['uiDynamicAdvLootID'] = 0,
}

-- ��ɫ��Ʒ
CommonTable_RoleItem =
{
['iValueChangeFlag'] = 0,
['uiID'] = 0,
['uiTypeID'] = 0,
['uiItemNum'] = 0,
['uiDueTime'] = 0,
['uiEnhanceGrade'] = 0,
['uiCoinRemainRecastTimes'] = 0,
['iAttrNum'] = 0,
['auiAttrData'] = nil,
['uiOwnerID'] = 0,
['bBelongToMainRole'] = 0,
['uiSpendIron'] = 0,
['uiPerfectPower'] = 0,
['uiSpendTongLingYu'] = 0,
}

-- ������Ŀ
CommonTable_UnLockItem =
{
['uiUnLockType'] = 0,
['uiUnLockID'] = 0,
['uiUnLockNum'] = 0,
}

-- ��ɫ����
CommonTable_RoleAttrDef =
{
['uiType'] = 0,
['iValue'] = 0,
['iBaseValue'] = 0,
}

-- ��ѧ����
CommonTable_MartialAttr =
{
['uiType'] = 0,
['iValue'] = 0,
}

-- ��ѧӰ��
CommonTable_MartialInfluence =
{
['uiAttrType'] = 0,
['uiMartialTypeID'] = 0,
['uiMartialValue'] = 0,
['uiMartialInit'] = 0,
}

-- ��ɫ��ѧ
CommonTable_RoleMartial =
{
['iValueChangeFlag'] = 0,
['uiID'] = 0,
['uiRoleUID'] = 0,
['uiTypeID'] = 0,
['uiLevel'] = 0,
['uiExp'] = 0,
['uiExtExpApp'] = 0,
['uiMaxLevel'] = 0,
['iMartialAttrSize'] = 0,
['akMartialAttrs'] = nil,
['iMartialUnlockItemSize'] = 0,
['auiMartialUnlockItems'] = nil,
['iMartialInfluenceSize'] = 0,
['akMartialInfluences'] = nil,
['iMartialUnlockSkillSize'] = 0,
['auiMartialUnlockSkills'] = nil,
['iStrongLevel'] = 0,
['iStrongCount'] = -1,
['uiAttr1'] = 0,
['uiAttr2'] = 0,
['uiAttr3'] = 0,
['uiColdTime'] = 0,
}

-- ��ɫ�츳
CommonTable_RoleGift =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiGiftSourceType'] = 0,
['bIsGrowUp'] = 0,
}

-- ��ɫ��Ը
CommonTable_RoleWishTask =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiState'] = 0,
['uiReward'] = 0,
['uiRoleCard'] = 0,
['bFirstGet'] = 0,
}

-- �øжȽṹ
CommonTable_RoleDisposition =
{
['iNums'] = 0,
['uiFromTypeID'] = 0,
['auiToTypeIDList'] = nil,
['aiValueList'] = nil,
}

-- ���ǽ�ɫ����
CommonTable_CreateRoleAttrData =
{
['uiAttrType'] = 0,
['iAttrValue'] = 0,
}

-- ���ǽ�ɫ����
CommonTable_CreateMainRole =
{
['uiTypeID'] = 0,
['uiChild'] = 0,
['uiRank'] = 0,
['uiAttrCount'] = 0,
['akAttrs'] = nil,
['uiGifts'] = 0,
['uiUnlock'] = 0,
}

-- ���ǽ�ɫ����
CommonTable_CreateBabyRole =
{
['uiTypeID'] = 0,
['uiBabyStateID'] = 0,
['uiChild'] = 0,
['uiAttrCount'] = 0,
['akAttrs'] = nil,
['uiGifts'] = 0,
['uiUnlock'] = 0,
}

-- ��������ƶ�NPC��Ϣ����
CommonTable_RandomCityMoveNpcInfo =
{
['uiRoleID'] = 0,
['uiSrcCityID'] = 0,
['uiDstCityID'] = 0,
['uiDstMapID'] = 0,
}

-- ���н�ɫЭ��
CommonTable_SeGameCmd_DisplayRoleInfo =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiLevel'] = 0,
['uiStrengthenLv'] = 0,
['uiHP'] = 0,
['uiMP'] = 0,
['uiRemainPoint'] = 0,
['uiFragment'] = 0,
['uiOverlayLevel'] = 0,
['aiAttrs'] = nil,
['iItemNum'] = 0,
['auiRoleItem'] = 0,
['auiEquipItem'] = 0,
}

-- ͽ����Ϣ
CommonTable_BabyStateInfo =
{
['uiStateID'] = 0,
['uiBabyID'] = 0,
['uiFatherID'] = 0,
['uiMotherID'] = 0,
['uiBirthday'] = 0,
['uiState'] = 0,
['uiNextLearnTime'] = 0,
['acPlayerName'] = 'nil',
['uiMasterNum'] = 0,
['auiMasters'] = nil,
}

-- ��ͼ����
CommonTable_MapData =
{
['iRoleCount'] = 0,
['auiRoleIDs'] = 0,
['uiNameID'] = 0,
['sBuildingImg'] = 'nil',
['uiBuildingType'] = 0,
['bCanShow'] = nil,
['bCanReturn'] = nil,
}

-- �Թ����θ�����
CommonTable_MazeGridData =
{
['uiID'] = 0,
['uiRow'] = 0,
['uiColumn'] = 0,
['eFirstType'] = 0,
['eSecondType'] = 0,
['uiCardID'] = 0,
['uiBaseCardTypeID'] = 0,
['bCanReplace'] = 0,
['bHasTriggered'] = 0,
['bHasExplored'] = 0,
['bIsUnlock'] = 0,
['uiEventRoleID'] = 0,
}

-- �Թ���������
CommonTable_MazeAreaData =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['iMazeGridCount'] = 0,
['auiMazeGridIDs'] = nil,
['uiTemplateTerrainID'] = 0,
}

CommonTable_SeMaze_Buff =
{
['iBuffTypeID'] = 0,
['iLayer'] = 0,
}

-- �Թ�����
CommonTable_MazeData =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiCurAreaIndex'] = 0,
['uiCurPosRow'] = 0,
['uiCurPosColumn'] = 0,
['iBuffCount'] = 0,
['auiBuffIDs'] = nil,
['iAreaCount'] = 0,
['auiAreaIDs'] = nil,
}

-- �Թ���Ƭ�������
CommonTable_MazeCardItemData =
{
['uiNameID'] = 0,
['uiModelID'] = 0,
}

-- �Թ���Ƭ����
CommonTable_MazeCardData =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiNameID'] = 0,
['uiArtSettingID'] = 0,
['uiNeverAutoMove'] = 0,
['uiNeverAutoTrigger'] = 0,
['uiPlotID'] = 0,
['uiRoleID'] = nil,
['kCardItem'] = nil,
['uiUnlockGiftType'] = nil,
['uiUnlockGiftLevel'] = nil,
['uiClickAudio'] = nil,
['uiCardType'] = nil,
['uiCardSecondType'] = nil,
['uiNeedResetTreasure'] = nil,
['uiTaskID'] = nil,
}

-- �Թ���̬��������
CommonTable_DynamicAdvLoot =
{
['uiID'] = 0,
['uiDataTypeID'] = 0,
['uiAdvLootType'] = 0,
['uiNum'] = 0,
}

-- NPC�ݻ�����
CommonTable_NpcEvolutionData =
{
['iValueChangeFlag'] = 0,
['uiNpcID'] = 0,
['uiID'] = 0,
['uiType'] = 0,
['iParam1'] = 0,
['iParam2'] = 0,
['iParam3'] = 0,
}

-- �ݻ���¼
CommonTable_EvolutionRecord =
{
['iValueChangeFlag'] = 0,
['uiID'] = 0,
['uiBaseID'] = 0,
['iParam1'] = 0,
['iParam2'] = 0,
['iParam3'] = 0,
['iParam4'] = 0,
['uiCityID'] = 0,
['iTime'] = 0,
}

-- ��ɾ�������
CommonTable_StoryItem =
{
['uiEnumType'] = 0,
['uiCompleteNum'] = 0,
}

-- ����
CommonTable_AwardItem =
{
['uiRewardType'] = 0,
['uiBaseID'] = 0,
['uiNum'] = 0,
}

-- ����
CommonTable_ScriptEndItem =
{
['uiScriptEndType'] = 0,
['uiNum'] = 0,
}

-- NPC��ɫ����
CommonTable_NpcData =
{
['uiTypeID'] = 0,
['uiIndex'] = 0,
['iGoodEvil'] = 0,
['uiStaticItemsFlag'] = 0,
['uiStaticEquipsFlag'] = 0,
}

-- ��һ�������
CommonTable_SePlayerCommonInfo =
{
['acPlayerName'] = 'nil',
['charPicUrl'] = 'nil',
['dwModelID'] = 0,
['dwSex'] = 0,
['dwWeekRoundTotalNum'] = 0,
['dwALiveDays'] = 0,
['bUnlockHouse'] = false,
['dwAchievePoint'] = 0,
['dwMeridiansLvl'] = 0,
['dwCreateTime'] = 0,
['dwLastLogoutTime'] = 0,
['dwChallengeWinTimes'] = 0,
['bRMBPlayer'] = false,
['dwTitleID'] = 0,
['acOpenID'] = 'nil',
['acVOpenID'] = 'nil',
['acIP'] = 'nil',
['dwHoodleScore'] = 0,
['dwNormalHighTowerMaxNum'] = 0,
['dwBloodHighTowerMaxNum'] = 0,
['dwRegimentHighTowerMaxNum'] = 0,
['dwPlayerLastScriptID'] = 0,
['dwNewBirdGuideState'] = 0,
}

-- ��ҹ�������
CommonTable_SePlayerFunctionInfo =
{
['dwLowInCompleteTextNum'] = 0,
['dwMidInCompleteTextNum'] = 0,
['dwHighInCompleteTextNum'] = 0,
['dwMeridianTotalLvl'] = 0,
['dwAchieveTotalNum'] = 0,
['dwLuckyValue'] = 0,
['dwChallengeWinTimes'] = 0,
['dwJingTieNum'] = 0,
['dwTianGongChui'] = 0,
['dwPerfectFenNum'] = 0,
['dwWangYouCaoNum'] = 0,
['dwHoodleBallNum'] = 0,
['dwRefreshBallNum'] = 0,
['dwDilatationNum'] = 0,
['dwLimitShopBigmapAciton'] = 0,
['dwFreeGiveBigCoin'] = 0,
['dwShopGoldRewardTime'] = 0,
['dwShopAdRewardTime'] = 0,
['dwBondPelletNum'] = 0,
['dwDailyRewardState'] = 0,
['dwFundAchieveOpen'] = 0,
['dwRedPacketGetTimes'] = 0,
['dwResDropActivityFuncValue1'] = 0,
['dwResDropActivityFuncValue2'] = 0,
['dwResDropActivityFuncValue3'] = 0,
['dwResDropActivityFuncValue4'] = 0,
['dwResDropActivityFuncValue5'] = 0,
['dwCurResDropCollectActivity'] = 0,
['dwZmFreeTickets'] = 0,
['dwZmTickets'] = 0,
['bZmNewFlag'] = 0,
['dwTreaSureExchangeValue1'] = 0,
['dwTreaSureExchangeValue2'] = 0,
['dwFestivalValue1'] = 0,
['dwFestivalValue2'] = 0,
['dwTongLingYu'] = 0,
}

-- �����������
CommonTable_SePlayerAppearanceInfo =
{
['acPlayerName'] = 'nil',
['dwTitleID'] = 0,
['dwPaintingID'] = 0,
['dwModelID'] = 0,
['charPicUrl'] = 'nil',
['dwBackGroundID'] = 0,
['dwBGMID'] = 0,
['dwPoetryID'] = 0,
['dwPedestalID'] = 0,
['dwShowRoleID'] = 0,
['dwShowPetID'] = 0,
['dwLoginWordID'] = 0,
['dwHeadBoxID'] = 0,
['dwChatBoxID'] = 0,
['dwLandLadyID'] = 0,
}

-- ���Ѻ����¿�
CommonTable_SeQueryFriendRMBFlagResult =
{
['defPlayerID'] = 0,
['bRMBPlayer'] = false,
['bAdvancePurchase'] = false,
}

-- ����/�������Ը���
CommonTable_SePlayerAttriUpdate =
{
['acKey'] = 'nil',
['acValue'] = 'nil',
}

-- ���ѻ�������
CommonTable_SeFriendCommonInfo =
{
['defFriendID'] = 0,
['acFriendName'] = 'nil',
['charPicUrl'] = 'nil',
['acOpenID'] = 'nil',
['dwSex'] = 0,
['dwTitleID'] = 0,
['dwModelID'] = 0,
['dwAchievePoint'] = 0,
['dwMeridiansLvl'] = 0,
['dwLogoutTime'] = 0,
['bRMBPlayer'] = false,
['bAdvancePurchase'] = false,
['acVOpenID'] = 'nil',
}

-- �����ʶ
CommonTable_TaskTagData =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiValue'] = 0,
}

-- ��������״̬
CommonTable_TaskDescState =
{
['uiDescID'] = 0,
['uiDescState'] = 0,
['auiDescProcess'] = nil,
}

CommonTable_SePlayerCheat =
{
['acParam'] = 'nil',
}

-- ��Ʒ������Ʒ
CommonTable_ShopItem =
{
['uiShopItemID'] = nil,
['uiNum'] = nil,
['uiPrice'] = nil,
}

-- �����¼�
CommonTable_CityEvent =
{
['uiPos'] = nil,
['uiType'] = nil,
['uiTag'] = nil,
['uiEx'] = nil,
['uiTask'] = nil,
}

-- ��������
CommonTable_CityData =
{
['uiCityID'] = 0,
['uiWeatherID'] = 0,
['uiState'] = 0,
['iNum'] = 0,
['akCityEvents'] = nil,
['iCityDispo'] = 0,
['uiTimerCount'] = 0,
['auiTimers'] = nil,
}

-- ��������
CommonTable_PetData =
{
['uiBaseID'] = 0,
['uiFragment'] = 0,
}

-- �ǳ�����
CommonTable_NickNameData =
{
['uiNpcID'] = 0,
['acName'] = 'nil',
}

CommonTable_SeBattle_GameEndAward =
{
['iValueChangeFlag'] = 0,
['uiItemID'] = 0,
['uiNums'] = 0,
['eType'] = 0,
}

CommonTable_SeBattle_GameEnd =
{
['iValueChangeFlag'] = 0,
['iTypeID'] = 0,
['iEndScore'] = 0,
['eFlag'] = 0,
['iScoreNum'] = 0,
['uiTeamExp'] = 0,
['uiMartialExp'] = 0,
['uiResultAddExp'] = 0,
['uiLevelAddExp'] = 0,
['aiScoreType'] = nil,
['aiScoreCount'] = nil,
['aiScore'] = nil,
['iAwardNum'] = 0,
['asAward'] = nil,
}

CommonTable_SeBattle_BattleMartial =
{
['uiMartialIndex'] = 0,
['uiMartialID'] = 0,
['uiMartialItemID'] = 0,
['uiMartialLevel'] = 0,
['uiRangeLevel'] = 0,
['uiDamageValue'] = 0,
['uiPower'] = 0,
['uiPowerBase'] = 0,
['uiPowerPercent'] = 0,
['uiCostMP'] = 0,
['eStateFalg'] = 0,
['uiSkillEvolution'] = 0,
['eParamInfo'] = 0,
['uiColdTime'] = 0,
['uiRoleUID'] = 0,
}

CommonTable_SeGameCmd_BuffDesc =
{
['iBuffIndex'] = 0,
['iDescLangID'] = 0,
['iParam1'] = 0,
['iParam2'] = 0,
['iDescType'] = 0,
}

CommonTable_SeGameCmd_UpdateRound =
{
['iRoundNum'] = 0,
}

CommonTable_SeBattle_Buff =
{
['iBuffIndex'] = 0,
['iBuffTypeID'] = 0,
['iLayerNum'] = 0,
['iRoundNum'] = 0,
}

CommonTable_SeBattle_UnitNpcEquip =
{
['iInstID'] = 0,
['iTypeID'] = 0,
['iEnhanceGrade'] = 0,
}

CommonTable_SeBattle_ComboRecord =
{
['uiComboID'] = 0,
['iCount'] = 0,
}

-- ������ɫ
CommonTable_RoleFaceData =
{
['uiHat'] = 0,
['uiBack'] = 0,
['uiHairBack'] = 0,
['uiBody'] = 0,
['uiFace'] = 0,
['uiEyebrow'] = 0,
['uiEye'] = 0,
['uiMouth'] = 0,
['uiNose'] = 0,
['uiForeheadAdornment'] = 0,
['uiFacialAdornment'] = 0,
['uiHairFront'] = 0,
['iEyebrowWidth'] = 0,
['iEyebrowHeight'] = 0,
['iEyebrowLocation'] = 0,
['iEyeWidth'] = 0,
['iEyeHeight'] = 0,
['iEyeLocation'] = 0,
['iNoseWidth'] = 0,
['iNoseHeight'] = 0,
['iNoseLocation'] = 0,
['iMouthWidth'] = 0,
['iMouthHeight'] = 0,
['iMouthLocation'] = 0,
['uiModelID'] = 0,
['uiSex'] = 0,
['uiCGSex'] = 0,
['uiRoleID'] = 0,
}

CommonTable_SeGameCmd_BattleUnitCreate =
{
['iValueChangeFlag'] = 0,
['uiUnitIndex'] = 0,
['iGridX'] = 0,
['iGridY'] = 0,
['iMP'] = 0,
['iHP'] = 0,
['iMAXMP'] = 0,
['iMAXHP'] = 0,
['uiRoleID'] = 0,
['uiTypeID'] = 0,
['uiModleID'] = 0,
['uiNameID'] = 0,
['uiFamilyNameID'] = 0,
['uiFirstNameID'] = 0,
['iAssistFlag'] = 0,
['iFace'] = 1,
['eCamp'] = SE_INVALID,
['iEquipItemNum'] = 0,
['akEquipItem'] = nil,
['iSex'] = 0,
['kRoleFaceData'] = nil,
}

CommonTable_SeGameCmd_BattleUnit =
{
['iValueChangeFlag'] = 0,
['uiUnitIndex'] = 0,
['iGridX'] = 0,
['iGridY'] = 0,
['iMP'] = 0,
['iHP'] = 0,
['iMAXMP'] = 0,
['iMAXHP'] = 0,
['iRoundHP'] = 0,
['iRoundMP'] = 0,
['iShield'] = 0,
['iAssistFlag'] = 0,
['iFace'] = 1,
['eMaxAttackType'] = 0,
['iMaxAttack'] = 0,
['iDefend'] = 0,
['iMoveValue'] = 0,
['iMoveDistance'] = SSD_BATTLE_INIT_MOVE,
['iBuffNum'] = 0,
['akBuffData'] = nil,
['iChuanTouCiShu'] = 0,
}

CommonTable_SeGameCmd_BattleUnitComboInfo =
{
['uiUnitIndex'] = 0,
['iComboNum'] = 0,
['aiComboBaseID'] = nil,
}

CommonTable_SeBattle_UnitTime =
{
['uiUnitIndex'] = 0,
['fMoveTime'] = 0,
['fOptNeedTime'] = 0,
}

CommonTable_SeBattle_UnitMartial =
{
['iSkillNum'] = 0,
['akMartial'] = nil,
}

CommonTable_SeGameCmd_BattleUnitObserve =
{
['iValueChangeFlag'] = 0,
['uiUnitIndex'] = 0,
['iMAXMP'] = 0,
['iMAXHP'] = 0,
['iDefend'] = 0,
['iMoveValue'] = 0,
['iBuffNum'] = 0,
['akBuffData'] = nil,
['aiAttrs'] = nil,
['uiLevel'] = 0,
['iGoodEvil'] = 0,
['iRank'] = 0,
['iClan'] = 0,
['akUnitsMartial'] = nil,
}

CommonTable_SeGameCmd_BattleAssistUnit =
{
['iValueChangeFlag'] = 0,
['uiTypeID'] = 0,
['eCamp'] = SE_INVALID,
['bPet'] = 0,
['uiLevel'] = 0,
['uiMoedlID'] = 0,
}

CommonTable_SeBattle_TreasureBox =
{
['iGridX'] = 0,
['iGridY'] = 0,
['uiDropTypeID'] = 0,
['uiLevel'] = 0,
['iFlag'] = 0,
['iNum'] = 0,
['akReward'] = nil,
}

CommonTable_SeBattle_SkillDamageData =
{
['iValueChangeFlag'] = 0,
['iTargetUnitIndex'] = 0,
['iFinalDamageValue'] = 0,
['iFinalMPDamageValue'] = 0,
['iFinalHPAddValue'] = 0,
['iFinalValueFlag'] = 0,
['iDuoDuanNum'] = 0,
['aiFinalNumberAddValue'] = nil,
['iLeechValue'] = 0,
['iShieldValue'] = 0,
['iReboundDamageValue'] = 0,
['eSkillDataType'] = 1,
['eExtraFlag'] = BDEF_NULL,
['iJituiX'] = 100,
['iJituiY'] = 100,
['iYuanhuX'] = -1,
['iYuanhuY'] = -1,
['iExtraFinalDamageAddValue'] = 0,
['iExtraFinalDamageAddPer'] = 0,
['iExtraFinalHPAddValue'] = 0,
['iExtraFinalHPAddPer'] = 0,
['iBaseDamageValue'] = 0,
['iBaseHPAddValue'] = 0,
['iNumberAddPer'] = 0,
['iNumberAddValue'] = 0,
['iCurNumberAddValue'] = 0,
['eSpecialFlag'] = 0,
['iAddPassTime'] = 0,
['iDodge'] = 0,
}

CommonTable_SeBattle_YuanHuData =
{
['iTargetIndex'] = 0,
['iYuanHuIndex'] = 0,
['iMartialIndex'] = 0,
}

CommonTable_SeBattle_Plot =
{
['eEventType'] = 0,
['iPlotTaskID'] = 0,
['iPlotID'] = 0,
['PlotType'] = 0,
['Param1'] = 0,
['Param2'] = 0,
['Param3'] = 0,
['Param4'] = 0,
['Param5'] = 0,
}

CommonTable_SeBattle_HurtInfoBuff =
{
['iValueChangeFlag'] = 0,
['iOwnUnitIndex'] = 0,
['eEventType'] = 0,
['iBuffIndex'] = 0,
['iBuffTypeID'] = 0,
['iLayerNum'] = 0,
['iRoundNum'] = 0,
['iFlag'] = SBHBT_NULL,
}

CommonTable_SeBattle_HurtInfo =
{
['iValueChangeFlag'] = 0,
['eEvent'] = 0,
['iOwnerUnitIndex'] = 0,
['iOwnerMartialIndex'] = 0,
['iSkillTypeID'] = 0,
['iBuffIndex'] = 0,
['iBuffTypeID'] = 0,
['iBuffDamage'] = 0,
['iSourceUnitIndex'] = 0,
['iSourceMartialIndex'] = 0,
['iCastPosX'] = -1,
['iCastPosY'] = -1,
['iMoveX'] = -1,
['iMoveY'] = -1,
['iSpendMP'] = 0,
['iAddMP'] = 0,
['iAddHP'] = 0,
['iSpendItemID'] = 0,
['iLianJiCount'] = 100,
['eSkillEventType'] = BSET_Null,
['iBuffNum'] = 0,
['akBuffData'] = nil,
['iPlotNum'] = 0,
['akPlotData'] = nil,
['iHeJiTargetNum'] = 0,
['aiHeJiTargetUnit'] = nil,
['iSkillDamageData'] = 0,
['akSkillDamageData'] = nil,
['iMutilTag'] = 0,
['bDeath'] = 0,
['iCallDiscipleIndex'] = 0,
['iPetNum'] = 0,
['aiPetID'] = nil,
}

CommonTable_RoleEmbattle =
{
['uiRoleID'] = 0,
['iID'] = 0,
['iRound'] = 0,
['iGridX'] = 0,
['iGridY'] = 0,
['eFlag'] = INVALID,
['bPet'] = false,
['uiFlag'] = 0,
}

-- ����ʱ��ṹ
CommonTable_InteractDate =
{
['uiRoleID'] = 0,
['eInteractType'] = NPCIT_UNKNOW,
['uiTimes'] = 0,
['iChangeType'] = -1,
}

-- ����ѡ��ṹ
CommonTable_InteractOption =
{
['uiChoiceLangID'] = 0,
['uiLockLangID'] = 0,
['uiRoleTypeID'] = 0,
['uiMapID'] = 0,
['uiConditionID'] = 0,
['bIsLock'] = 0,
['uiMazeTypeID'] = 0,
['uiAreaIndex'] = 0,
['uiCardID'] = 0,
['uiRow'] = 0,
['uiColumn'] = 0,
['eInteractType'] = 0,
['uiTaskID'] = 0,
}

-- ѡ���ɫ�¼��ṹ
CommonTable_RoleSelectEvent =
{
['uiRoleTypeID'] = 0,
['uiMapTypeID'] = 0,
['uiMazeTypeID'] = 0,
['uiAreaIndex'] = 0,
['uiCardTypeID'] = 0,
['uiRow'] = 0,
['uiColumn'] = 0,
}

-- չʾ_��������Ʒ����
CommonTable_NPCInteractRandomItems =
{
['uiRoleID'] = 0,
['uiItemTypeID'] = 0,
['iNum'] = 0,
['iItemP'] = 0,
['iTreasureP'] = 0,
['iRandomItemNum'] = nil,
['eInteractType'] = NPCIT_UNKNOW,
['auiRoleItem'] = nil,
}

-- ���а���Ϣ
CommonTable_SeRankInfo =
{
['acUserID'] = 'nil',
['acRankID'] = 'nil',
['acMember'] = 'nil',
['acScore'] = 'nil',
['bIsAdd'] = 1,
['iPage'] = 1,
['iPageNum'] = 10,
['bIsAsc'] = 1,
['acSnap'] = 'nil',
['bIsSnap'] = 0,
['iStart'] = 0,
['iStop'] = -1,
}

-- ���а�����
CommonTable_SeRanklistData =
{
['uiRankID'] = 0,
['uiScore'] = 0,
['bIsAdd'] = 0,
}

-- �����������к�������ʱ����Ϣ
CommonTable_DebugFuncCallInfo =
{
['acFuncName'] = 'nil',
['uiCallTimes'] = 0,
['uiCallCostTime'] = 0,
}

-- ʵ����ɫ����
CommonTable_SeInstRole =
{
['uiTypeID'] = 0,
['uiNameID'] = nil,
['uiTitleID'] = nil,
['uiFamilyNameID'] = 0,
['uiFirstNameID'] = 0,
['uiLevel'] = nil,
['uiClanID'] = nil,
['uiHP'] = nil,
['uiMP'] = nil,
['uiExp'] = nil,
['uiRemainAttrPoint'] = nil,
['uiFragment'] = nil,
['uiOverlayLevel'] = nil,
['iGoodEvil'] = nil,
['uiRemainGiftPoint'] = nil,
['uiModelID'] = nil,
['uiRank'] = nil,
['uiMartialNum'] = nil,
['uiEatFoodNum'] = nil,
['uiMarry'] = nil,
['uiSubRole'] = nil,
['auiFavor'] = 0,
['uiBroAndSisNum'] = nil,
['auiBroAndSis'] = 0,
['aiAttrs'] = nil,
['iItemNum'] = nil,
['auiRoleItem'] = nil,
['auiEquipItem'] = nil,
['iMartialNum'] = nil,
['auiRoleMartials'] = nil,
['auiEmbattleMartials'] = nil,
['giftNum'] = nil,
['auiRoleGift'] = nil,
['iWishTasksNum'] = nil,
['auiRoleWishTasks'] = nil,
['auiHeritGift'] = nil,
['auiHeritMartial'] = nil,
}

-- ƽ̨��ɫ��������
CommonTable_SePlatRoleCommon =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiNameID'] = 0,
['uiTitleID'] = 0,
['uiFamilyNameID'] = 0,
['uiFirstNameID'] = 0,
['uiLevel'] = 0,
['uiClanID'] = 0,
['uiHP'] = 0,
['uiMP'] = 0,
['uiExp'] = 0,
['uiRemainAttrPoint'] = 0,
['uiFragment'] = 0,
['uiOverlayLevel'] = 0,
['iGoodEvil'] = 0,
['uiRemainGiftPoint'] = 0,
['uiModelID'] = 0,
['uiRank'] = 0,
['uiMartialNum'] = 0,
['uiEatFoodNum'] = 0,
['uiEatFoodMaxNum'] = 0,
['uiMarry'] = 0,
['uiSubRole'] = 0,
['uiFavorNum'] = 0,
['auiFavor'] = nil,
['uiBroAndSisNum'] = 0,
['auiBroAndSis'] = nil,
}

-- ��һ�����Ϣ
CommonTable_ArenaMemberData =
{
['defPlayerID'] = 0,
['dwModelID'] = 0,
['dwOnlineTime'] = 0,
['dwMerdianLevel'] = 0,
['acPlayerName'] = 'nil',
['charPicUrl'] = 'nil',
['dwRoleID'] = 0,
}

-- ��̨��������������
CommonTable_SeArenaMatchPkData =
{
['iPkDataFlag'] = 0,
['iDataSize'] = 0,
['akData'] = nil,
}

-- ��̨��������
CommonTable_SeArenaMatchData =
{
['dwMatchType'] = 0,
['dwMatchID'] = 0,
['dwBufferID'] = 0,
['dwSignUpCount'] = 0,
['uiStage'] = 0,
['dwRoundID'] = 0,
['uiSignUpPlace'] = 0,
['dwRank'] = 0,
['dwBetWinTimes'] = 0,
['dwBetWinMoney'] = 0,
['dwBattleTime'] = 0,
}

-- ��̨ս������
CommonTable_SeArenaBattleData =
{
['dwBattleID'] = 0,
['dwRoundID'] = 0,
['dwPly1BetRate'] = 0,
['dwPly2BetRate'] = 0,
['defPlyWinner'] = 0,
['defBetPlyID'] = 0,
['dwBetMoney'] = 0,
['kPly1Data'] = nil,
['kPly2Data'] = nil,
}

-- ��̨����������Ϣ
CommonTable_SeArenaJokeBattleData =
{
['acPlayerName'] = 'nil',
['charPicUrl'] = 'nil',
['dwModelID'] = 0,
['dwResult'] = 0,
}

-- ��̨���������
CommonTable_SeArenaMemberName =
{
['acPlayerName'] = 'nil',
}

-- ��̨��Ѻעʤ�������
CommonTable_SeArenaBetRankMember =
{
['defPlayerID'] = 0,
['acPlayerName'] = 'nil',
['dwValue'] = 0,
}

-- ��̨��ɽ���������
CommonTable_SeArenaHuaShanMember =
{
['dwMatchType'] = 0,
['defPlayerID'] = 0,
['acPlayerName'] = 'nil',
}

-- ��̨����ʷ���
CommonTable_SeArenaHistoryMember =
{
['defPlayerID'] = 0,
['acPlayerName'] = 'nil',
['charPicUrl'] = 'nil',
['dwModelID'] = 0,
['dwPlace'] = 0,
}

-- ��̨����ʷ����
CommonTable_SeArenaMatchHistoryData =
{
['dwMatchType'] = 0,
['dwMatchID'] = 0,
['dwMatchTime'] = 0,
['dwPlace'] = 0,
['dwBetWinTimes'] = 0,
['dwBetWinMoney'] = 0,
['akMemberHistoryData'] = nil,
}

-- ��̨ս������
CommonTable_ArenaBattleCalcInfo =
{
['uiMatchType'] = 0,
['uiMatchID'] = 0,
['uiRoundID'] = 0,
['uiBattleID'] = 0,
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['uiBuffTypeID'] = 0,
['uiArenaTypeID'] = 0,
['uiEnemyArenaTypeID'] = 0,
['iPly1PkDataCount'] = 0,
['iPly2PkDataCount'] = 0,
['akPly1PkData'] = nil,
['akPly2PkData'] = nil,
}

-- ��̨ս������
CommonTable_ArenaBattleCalcResultInfo =
{
['uiMatchType'] = 0,
['uiMatchID'] = 0,
['uiRoundID'] = 0,
['uiBattleID'] = 0,
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['aiClan1'] = 0,
['aiClan2'] = 0,
['uiWinnerID'] = 0,
['iRecordDataSize'] = 0,
['akRecordData'] = nil,
}

-- �д�ս������
CommonTable_ChallengePlatRoleCalcInfo =
{
['uiClientID1'] = 0,
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['uiModelID2'] = 0,
['uiMeridian2'] = 0,
['acPly1Name'] = 'nil',
['acPly2Name'] = 'nil',
['iPly1PkDataCount'] = 0,
['iPly2PkDataCount'] = 0,
['akPly1PkData'] = nil,
['akPly2PkData'] = nil,
['uiBattleID'] = 0,
['uiMatchType'] = 0,
}

-- �д�ս������
CommonTable_ChallengePlatRoleCalcInfoEx =
{
['uiClientID1'] = 0,
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['uiModelID2'] = 0,
['uiMeridian2'] = 0,
['acPly1Name'] = 'nil',
['acPly2Name'] = 'nil',
['iPly1PkDataCount'] = 0,
['iPkDataFlag1'] = 0,
['iDataSize1'] = 0,
['akData1'] = nil,
['iPkDataFlag2'] = 0,
['iDataSize2'] = 0,
['akData2'] = nil,
}

-- �д�ս������
CommonTable_ChallengePlatRoleCalcResultInfo =
{
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['uiWinnerID'] = 0,
['iRecordDataSize'] = 0,
['akRecordData'] = nil,
}

-- ��Ҳ����ɫ��������
CommonTable_SePlatBaseRoleInfo =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiNameID'] = 0,
['uiTitleID'] = 0,
['uiFamilyNameID'] = 0,
['uiFirstNameID'] = 0,
['uiModelID'] = 0,
['uiRank'] = 0,
}

-- ���չʾ�籾��ɫ����
CommonTable_SePlatAppearanceRoles =
{
['uiMainRoleID'] = 0,
['acRoleName'] = 'nil',
['iNum'] = 0,
['akBaseRoleInfo'] = nil,
}

-- Map�ṹ
CommonTable_DwKeyDwValue =
{
['uiKey'] = 0,
['uiValue'] = 0,
}

-- ���а��ѯ���ݽṹ
CommonTable_SeRankData =
{
['defMember'] = 0,
['uiRank'] = 0,
['uiScore'] = 0,
}

-- ��ɫ���￨
CommonTable_RolePetCardData =
{
['uiCardID'] = 0,
['uiLevel'] = 0,
['uiCardNum'] = 0,
['uiUseFlag'] = 0,
}

-- �̳���Ʒ
CommonTable_PlatShopItem =
{
['uiShopID'] = 0,
['uiItemID'] = 0,
['uiProperty'] = 0,
['uiMoneyType'] = 0,
['iPrice'] = 0,
['iDiscount'] = 0,
['iFinalPrice'] = 0,
['uiFlag'] = 0,
['iRemainTime'] = 0,
['iCanBuyCount'] = -1,
['iMaxBuyNums'] = -1,
['iNeedUnlockType'] = -1,
['iNeedUnlockID'] = -1,
['iMaxBuyNumsPeriod'] = 0,
['iType'] = 0,
['iSort'] = 0,
}

-- ���а���������
CommonTable_SeRankUpdateInfo =
{
['defPlayerID'] = 0,
['acPlayerName'] = 'nil',
['uiRankID'] = 0,
['uiScore'] = 0,
['bIsAdd'] = 0,
}

-- ��Ҹ���
CommonTable_SePlayerChangeName =
{
['acUserID'] = 'nil',
['acRankID'] = 'nil',
['acMember'] = 'nil',
['acScore'] = 'nil',
['bIsAdd'] = 1,
['iPage'] = 1,
['iPageNum'] = 10,
['bIsAsc'] = 1,
['acSnap'] = 'nil',
['bIsSnap'] = 0,
['iStart'] = 0,
['iStop'] = -1,
}

-- ��������Ϣ�ְ��ṹ��
CommonTable_SeBigCmdBatchData =
{
['uiTotalSize'] = 0,
['uiBatchIdx'] = 0,
['uiBatchSize'] = nil,
['akData'] = nil,
}

-- ��Ѷ���÷�
CommonTable_SeTencentCreditScore =
{
['iScore'] = 0,
['iTagBlack'] = 0,
['iMTime'] = nil,
}

-- �������а񷵻�
CommonTable_SeUpdateRankRet =
{
['dwRankID'] = 'nil',
['acMember'] = 'nil',
['acScore'] = 'nil',
['dwBeforeRank'] = 0,
['dwAfterRank'] = 0,
['bSucessful'] = false,
}

-- ����������Ϣ
CommonTable_MainRoleInfo =
{
['uiDataType'] = 0,
['uiValue'] = 0,
}

-- ��ʱ�̵�
CommonTable_SeLimitShopData =
{
['nDataId'] = 0,
['nTypeId'] = 0,
['nShareTimes'] = 0,
['nBuyBits'] = 0,
}

-- ��ʱ�̵�
CommonTable_SeLimitShopDiscountData =
{
['nDiscount'] = 0,
['nOverTime'] = 0,
}

-- ��ʱ�̵����
CommonTable_SeLimitShopOpParam =
{
['defPlayerID'] = 0,
['eOprType'] = EN_LIMIT_SHOP_GET,
['iType'] = 0,
['iParams0'] = 0,
['iParams1'] = 0,
['iParams2'] = 0,
['iParams3'] = 0,
['acData'] = 'nil',
}

-- �ƺŰ�����
CommonTable_SeTitleRankID2PlayerIDs =
{
['uiRankID'] = 0,
['defPlayerID'] = 0,
['iSendMailCnt'] = 0,
}

-- ���ƺ��淨����
CommonTable_SeGrabTitleData =
{
['uiNpcID'] = 0,
['uiLevel'] = 0,
['uiRank'] = 0,
['uiClan'] = 0,
['iMartialsNum'] = 0,
['iGiftsNum'] = 0,
['iAttrNum'] = 0,
['akMartials'] = nil,
['akGifts'] = nil,
['akAttr'] = nil,
}

-- ������Ϣ
CommonTable_SeZMEquipInfo =
{
['dwBaseId'] = 0,
['dwLv'] = 0,
['dwId'] = 0,
}

-- ������Ϣ
CommonTable_SeZMCardInfo =
{
['dwBaseId'] = 0,
['dwLv'] = 0,
['dwId'] = 0,
['dwEquipId'] = 0,
['wX'] = 0,
['wY'] = 0,
}

-- ����ģ����Ϣ
CommonTable_SeZMCardData =
{
['dwBaseId'] = 0,
['dwCardNum'] = 0,
}

-- ѡ������Ϣ
CommonTable_SeZMCardSelectInfo =
{
['dwBaseId'] = 0,
['dwLv'] = 0,
}

-- ֪ͨ��Ϣ
CommonTable_SeZMNoticePair =
{
['dwFirst'] = 0,
['dwSecond'] = 0,
}

-- �����Ϣ
CommonTable_SeZMPlayerInfo =
{
['akBattleCardData'] = nil,
['iCardNum'] = 0,
['akCardData'] = nil,
['iEquipNum'] = 0,
['akEquipData'] = nil,
['dwClan'] = 0,
['dwBattleCardNum'] = 0,
}

-- �����չ��Ϣ
CommonTable_SeZMPlayerInfoExt =
{
['akSelectCardData'] = nil,
['akSelectClanData'] = nil,
['akSelectEquipData'] = nil,
['dwRound'] = 0,
['dwEventId'] = 0,
['dwReflashTimes'] = 0,
['dwSkillUseTimes'] = 0,
['dwGold'] = 0,
}

-- ���������Ϣ
CommonTable_SeZMOtherPlayerInfo =
{
['defPlayerID'] = 0,
['acPlayerName'] = 'nil',
['akCardData'] = nil,
['akEquipData'] = nil,
['dwClan'] = 0,
['dwBuffID'] = 0,
['dwClanBuffID'] = 0,
['dwClanBuffCount'] = 0,
}

-- ���ŶԾ�ս������
CommonTable_ZmBattleCalcInfo =
{
['nRoomId'] = 0,
['uiRoundID'] = 0,
['uiBattleID'] = 0,
['uiFightID'] = 0,
['kPlayerInfo1'] = nil,
['kPlayerInfo2'] = nil,
['iFreezeCardNum'] = 0,
['akFreezeCardData'] = nil,
}

-- ���ŶԾ�ս������
CommonTable_ZmBattleCalcResultInfo =
{
['nRoomId'] = 0,
['uiRoundID'] = 0,
['uiBattleID'] = 0,
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['uiWinnerID'] = 0,
['iRecordDataSize'] = 0,
['akRecordData'] = nil,
}

-- ���ŶԾ�ս������
CommonTable_SeZmBattleData =
{
['uiBattleID'] = 0,
['uiRoundID'] = 0,
['uiWinnerID'] = 0,
['kPly1Data'] = nil,
['kPly2Data'] = nil,
}

-- ��һ�����Ϣ
CommonTable_ZmMemberData =
{
['kPlyData'] = nil,
['bRobot'] = 0,
}

-- ��������
CommonTable_SeZmCardBattle =
{
['dwId'] = 0,
['dwBattleIndex'] = 0,
['wX'] = 0,
['wY'] = 0,
}

-- ��ɫ��
CommonTable_RoleCardData =
{
['dwRoleID'] = 0,
['dwLevel'] = 0,
}

-- �����̵�
CommonTable_SeZmShopItem =
{
['dwRoleId'] = 0,
['dwRoleNum'] = 0,
}

-- ���ɹ���������Ϣ
CommonTable_SectWorkshopItemInfo =
{
['dwItemID'] = 0,
['dwItemNum'] = 0,
['dwUpdateTime'] = 0,
}

-- ���ɽ�����Ϣ
CommonTable_SectBuildingInfo =
{
['dwBuildingID'] = 0,
['dwBuildingType'] = 0,
['dwBuildingLevel'] = 0,
['dwBuildingPos'] = 0,
['dwPreBuildingID'] = 0,
['acName'] = 'nil',
['dwBackGroundID'] = 0,
['dwUpgradeEndTime'] = 0,
['iNum'] = 0,
['akWorkshopItemInfo'] = nil,
['akDiscipleInfo'] = nil,
}

-- ����λ����Ϣ
CommonTable_SectBuildingPos =
{
['dwBuildingID'] = 0,
['dwBuildingPos'] = 0,
['dwPreBuildingID'] = 0,
}

-- ���ɲֿ������Ϣ
CommonTable_SectStoreItemInfo =
{
['dwItemID'] = 0,
['dwItemNum'] = 0,
}

-- ���ɲֿ�洢��Ϣ
CommonTable_SectStoreInfo =
{
['iNum'] = 0,
['akStoreItemInfo'] = nil,
}

-- ���ػ��Ϣ�ṹ
CommonTable_SeActivityRetInfo =
{
['dwActivityID'] = 0,
['iReset_time'] = 0,
['iCycle_count'] = 0,
['iHistory_count'] = 0,
['iState'] = 0,
['iValue1'] = 0,
['iValue2'] = 0,
['iValue3'] = 0,
['bEnabled'] = false,
}

-- �籾��������Ϣ
CommonTable_SeStoryWeekLimitInfo =
{
['dwStoryID'] = 0,
['iTakeOutNum'] = 0,
}

-- �ͻ���������̨��������
CommonTable_SeRequestArenaMatchOperateCmd =
{
['eRequestType'] = ARENA_REQUEST_NULL,
['uiMatchType'] = 0,
['uiMatchID'] = 0,
['uiRoundID'] = 0,
['uiBattleID'] = 0,
['kPlayerID'] = 0,
['iUploadFlag'] = 0,
}

