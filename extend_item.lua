-- 選択中のアイテムを取得
local num_selected_items = reaper.CountSelectedMediaItems(0)

for i = 0, num_selected_items - 1 do
    local item = reaper.GetSelectedMediaItem(0, i)
    local track = reaper.GetMediaItem_Track(item)
    
    -- アイテムの次のアイテムを取得
    local next_item = reaper.GetTrackMediaItem(track, reaper.GetMediaItemInfo_Value(item, "IP_ITEMNUMBER") + 1)
    
    if next_item then
        -- 次のアイテムの開始位置を取得
        local next_item_start = reaper.GetMediaItemInfo_Value(next_item, "D_POSITION")
        
        -- 現在のアイテムの開始位置を取得
        local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        
        -- アイテムの長さを次のアイテムの開始位置まで拡張
        reaper.SetMediaItemInfo_Value(item, "D_LENGTH", next_item_start - item_start)
    end
end

-- 更新して画面に反映
reaper.UpdateArrange()
