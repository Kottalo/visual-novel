import os
import re
import sys
from collections import defaultdict
from pathlib import Path

import requests

from feishu_auth import get_tenant_token, APP_TOKEN

if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent
BASE_URL = "https://open.feishu.cn/open-apis"

# 数据表ID
BODY_TABLE_ID = "tblfJaAJJurvAjqO"  # 动作数据表
CHARACTER_TABLE_ID = "tbli3JZz1BSky0F1"  # 角色数据表

# 字段名
CHARACTER_NAME_FIELD = "名称"  # 角色数据表中的角色名
LINK_CHARACTER_FIELD = "角色"  # 动作数据表中关联角色的字段

# 角色目录
CHARACTERS_DIR = REPO_ROOT / "characters" / "instances"


def parse_tscn_file(filepath):
    """解析 tscn 文件，提取角色动作"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 提取角色名（从文件名）
    character_name = os.path.basename(filepath).replace('character_', '').replace('.tscn', '')

    # 直接在文件中查找所有动画名称
    animations = []
    name_pattern = r'"name": &"([^"]+)"'
    for name_match in re.finditer(name_pattern, content):
        anim_name = name_match.group(1)
        if anim_name not in animations:  # 去重并保持顺序
            animations.append(anim_name)

    return character_name, animations


def is_action(anim_name):
    """判断是否为动作（带"-"）"""
    return '-' in anim_name


def parse_animation_name(anim_name):
    """解析动画名称，返回（服装，动作）"""
    parts = anim_name.split('-', 1)
    return parts[0].strip(), parts[1].strip()


def extract_text(field_value):
    """从飞书字段值中提取纯文本"""
    if isinstance(field_value, str):
        return field_value.strip()

    if isinstance(field_value, list):
        if not field_value:
            return ""
        first = field_value[0]
        if isinstance(first, dict):
            return first.get("text", "").strip()
        if isinstance(first, str):
            return first.strip()

    if isinstance(field_value, dict):
        value = field_value.get("value")
        if isinstance(value, list) and value:
            first = value[0]
            if isinstance(first, dict):
                return first.get("text", "").strip()
            if isinstance(first, str):
                return first.strip()

    return ""


def extract_link_record_ids(field_value):
    """从飞书关联字段中提取 record_id 列表"""
    if isinstance(field_value, dict):
        link_record_ids = field_value.get("link_record_ids", [])
        if isinstance(link_record_ids, list):
            return [record_id for record_id in link_record_ids if record_id]
    return []


def get_all_records(token, table_id):
    """分页获取指定表的所有记录"""
    all_records = []
    page_token = None

    while True:
        params = {"page_size": 100}
        if page_token:
            params["page_token"] = page_token

        resp = requests.get(
            f"{BASE_URL}/bitable/v1/apps/{APP_TOKEN}/tables/{table_id}/records",
            headers={"Authorization": f"Bearer {token}"},
            params=params,
            timeout=60
        )
        result = resp.json()

        if result.get("code") != 0:
            raise Exception(f"获取表 {table_id} 记录失败: {result}")

        data = result.get("data", {})
        all_records.extend(data.get("items", []))

        if not data.get("has_more", False):
            break

        page_token = data.get("page_token")

    return all_records


def get_character_map(token):
    """获取角色名到 record_id 的映射"""
    records = get_all_records(token, CHARACTER_TABLE_ID)
    character_map = {}

    for record in records:
        fields = record.get("fields", {})
        name = extract_text(fields.get(CHARACTER_NAME_FIELD, ""))
        if name:
            character_map[name] = record["record_id"]

    return character_map


def get_body_groups(token):
    """获取身体表记录，并按（角色ID，服装）分组"""
    records = get_all_records(token, BODY_TABLE_ID)
    character_map = get_character_map(token)
    character_id_by_name = {name: record_id for name, record_id in character_map.items()}
    body_groups = defaultdict(list)

    for record in records:
        fields = record.get("fields", {})
        role_value = fields.get(LINK_CHARACTER_FIELD)
        role_ids = extract_link_record_ids(role_value)
        if role_ids:
            role_id = role_ids[0]
        else:
            role_name = extract_text(role_value)
            role_id = character_id_by_name.get(role_name)

        costume = extract_text(fields.get("服装", ""))
        action = extract_text(fields.get("动作", ""))

        if not role_id or not costume:
            print(f"  ! 跳过异常远程记录: {record.get('record_id')}")
            continue

        body_groups[(role_id, costume)].append({
            "record_id": record["record_id"],
            "role_record_id": role_id,
            "costume": costume,
            "action": action,
        })

    return body_groups


def build_local_body_groups(animations):
    """把本地动画整理成 服装 -> 动作列表 的映射"""
    local_groups = defaultdict(list)
    local_seen = defaultdict(set)

    for anim_name in animations:
        if not is_action(anim_name):
            continue

        costume, action = parse_animation_name(anim_name)
        if not costume or not action:
            print(f"    ! 跳过非法动作名: {anim_name}")
            continue

        if action in local_seen[costume]:
            continue

        local_groups[costume].append(action)
        local_seen[costume].add(action)

    return local_groups


def update_body_record(token, record_id, role_name, costume, action):
    """更新飞书身体表记录"""
    fields = {
        LINK_CHARACTER_FIELD: role_name,
        "服装": costume,
        "动作": action,
    }

    resp = requests.put(
        f"{BASE_URL}/bitable/v1/apps/{APP_TOKEN}/tables/{BODY_TABLE_ID}/records/{record_id}",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        json={"fields": fields},
        timeout=60
    )
    return resp.json()


def create_body_record(token, role_name, costume, action):
    """创建飞书身体表记录"""
    fields = {
        LINK_CHARACTER_FIELD: role_name,
        "服装": costume,
        "动作": action,
    }

    resp = requests.post(
        f"{BASE_URL}/bitable/v1/apps/{APP_TOKEN}/tables/{BODY_TABLE_ID}/records",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        json={"fields": fields},
        timeout=60
    )
    return resp.json()


def sync_body_group(
    token,
    character_name,
    costume,
    local_actions,
    remote_records,
):
    """同步单个（角色，服装）分组的动作"""
    skipped = 0
    updated = 0
    created = 0

    remote_by_action = defaultdict(list)
    for record in remote_records:
        remote_by_action[record["action"]].append(record)

    matched_record_ids = set()
    unmatched_local_actions = []

    for action in local_actions:
        exact_records = remote_by_action.get(action, [])
        if exact_records:
            record = exact_records.pop(0)
            matched_record_ids.add(record["record_id"])
            skipped += 1
            print(f"    ⏭ 跳过: {costume}-{action}")
        else:
            unmatched_local_actions.append(action)

    unmatched_remote_records = [
        record for record in remote_records
        if record["record_id"] not in matched_record_ids
    ]

    pair_count = min(len(unmatched_local_actions), len(unmatched_remote_records))
    for idx in range(pair_count):
        new_action = unmatched_local_actions[idx]
        remote_record = unmatched_remote_records[idx]
        result = update_body_record(
            token,
            remote_record["record_id"],
            character_name,
            costume,
            new_action,
        )

        if result.get("code") == 0:
            updated += 1
            print(f"    ✏️ 覆盖: {costume}-{remote_record['action']} -> {costume}-{new_action}")
        else:
            print(f"    ❌ 覆盖失败: {costume}-{new_action} - {result}")

    for action in unmatched_local_actions[pair_count:]:
        result = create_body_record(token, character_name, costume, action)
        if result.get("code") == 0:
            created += 1
            print(f"    ✅ 新增: {costume}-{action}")
        else:
            print(f"    ❌ 新增失败: {costume}-{action} - {result}")

    for record in unmatched_remote_records[pair_count:]:
        print(
            f"    ℹ️ 保留远程多余记录: {character_name} / {record['costume']} / {record['action']}"
        )

    return skipped, updated, created


def update_bodies():
    token = get_tenant_token()
    character_map = get_character_map(token)
    body_groups = get_body_groups(token)

    print(f"角色表记录: {len(character_map)}")
    print(f"身体表分组: {len(body_groups)}")

    total_skipped = 0
    total_updated = 0
    total_created = 0

    for filename in sorted(os.listdir(CHARACTERS_DIR)):
        if not filename.endswith('.tscn'):
            continue

        filepath = os.path.join(CHARACTERS_DIR, filename)
        print(f"\n处理文件: {filename}")
        character_name, animations = parse_tscn_file(filepath)
        role_record_id = character_map.get(character_name)

        if not role_record_id:
            print(f"  ! 飞书中找不到角色: {character_name}，跳过")
            continue

        local_groups = build_local_body_groups(animations)
        print(f"  角色ID: {role_record_id}")
        print(f"  找到 {sum(len(actions) for actions in local_groups.values())} 个动作")

        character_skipped = 0
        character_updated = 0
        character_created = 0

        for costume, local_actions in local_groups.items():
            print(f"  服装: {costume} ({len(local_actions)} 个动作)")
            group_key = (role_record_id, costume)
            remote_records = body_groups.get(group_key, [])

            skipped, updated, created = sync_body_group(
                token,
                character_name,
                costume,
                local_actions,
                remote_records,
            )

            character_skipped += skipped
            character_updated += updated
            character_created += created

        print(
            f"  → 跳过 {character_skipped} 条，覆盖 {character_updated} 条，新增 {character_created} 条"
        )

        total_skipped += character_skipped
        total_updated += character_updated
        total_created += character_created

    print("\n" + "=" * 60)
    print("同步完成")
    print(f"跳过: {total_skipped} 条")
    print(f"覆盖: {total_updated} 条")
    print(f"新增: {total_created} 条")
    print("=" * 60)


def main():
    update_bodies()


if __name__ == "__main__":
    main()
