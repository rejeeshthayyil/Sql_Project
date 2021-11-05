 select * from nationalhousingcopy

 select * from [NationalHousing ]
 
 select * into nationalhousingori
 from [NationalHousing ]
 select * from nationalhousingori

 --Standadardize date column

select * into nationalhousingori
from nationalhousingcopy

alter table nationalhousingori
alter column saledate date

--Populate property address

select * from nationalhousingori

select parcelid, propertyaddress from nationalhousingori
where  propertyaddress is null

select a.parcelid,b.parcelid,b.propertyaddress, isnull (a.propertyaddress,b.propertyaddress)
from nationalhousingori a
join nationalhousingori b
on a.ParcelID=b.ParcelID
--where a.propertyaddress is null
and a.[UniqueID ]<>b.[UniqueID ]

update a
set a.propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from nationalhousingori a
join nationalhousingori b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyaddress is null

select propertyaddress from nationalhousingori
where propertyaddress is null

--Breaking out address into individual column
select propertyaddress from nationalhousingori

select propertyaddress, substring(propertyaddress,1,charindex(',',propertyaddress)-1)As FirstlaneOFaddress,
SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))
from nationalhousingori

alter table nationalhousingori
add propertysplitaddress nvarchar(255)

update nationalhousingori
set propertysplitaddress =substring(propertyaddress,1,charindex(',',propertyaddress)-1)

alter table nationalhousingori
add propertysplitcity nvarchar(255)
update nationalhousingori
set propertysplitcity = SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))


select * from nationalhousingori

alter table nationalhousingori
drop column propertysplitcity

select top 10 * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'nationalhousingori'

select PARSENAME (REPLACE(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from nationalhousingori

alter table nationalhousingori
add Ownersplitaddress nvarchar(255)

alter table nationalhousingori
add Ownersplitcity nvarchar(255)

alter table nationalhousingori
add Ownersplitstate nvarchar(255)

update nationalhousingori
set Ownersplitaddress = PARSENAME (REPLACE(owneraddress,',','.'),3)

update nationalhousingori
set Ownersplitcity = PARSENAME(replace(owneraddress,',','.'),2) 
update nationalhousingori
set Ownersplitstate = PARSENAME(replace(owneraddress,',','.'),1)

--Changed 'y', and 'n'to 'Yes'and 'No'to soldvacant column

select  distinct SoldAsVacant, count(soldasvacant)total
from nationalhousingori
group by SoldAsVacant
order by total

select soldasvacant,
case when soldasvacant = 'y' then 'Yes'
when soldasvacant = 'n' then 'No'
else soldasvacant
end
from nationalhousingori

update nationalhousingori
set SoldAsVacant = case when soldasvacant = 'y' then 'Yes'
when soldasvacant = 'n' then 'No'
else soldasvacant
end 

-- Removes duplicate
select * from nationalhousingori




WITH Rownumbercte
as
(select * ,row_number ()  over (partition by parcelid,
propertyaddress,
saledate,
Legalreference,
Landvalue,
owneraddress
order by uniqueid)
row_num
from nationalhousingori)

select * from Rownumbercte
where row_num >1
order by PropertyAddress

--Deleate unused columns

select * from nationalhousingori

alter table nationalhousingori
drop column taxdistrict







