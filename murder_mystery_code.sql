--To begin with, reading the crime scene report:
SELECT description FROM crime_scene_report 
WHERE date = 20180115 AND type="murder" AND city = "SQL City";

-- report:
--"Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". 
--The second witness, named Annabel, lives somewhere on "Franklin Ave"."

-- Reading the interview of the first witness:
SELECT transcript FROM interview 
JOIN person ON interview.person_id = person.id 
WHERE person.address_street_name = "Northwestern Dr" 
ORDER BY address_number DESC
LIMIT 1;  

--transcript of the interview: 
--"I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
--The membership number on the bag started with "48Z". 
--Only gold members have those bags. The man got into a car with a plate that included "H42W"."

---- Reading the interview of the second witness:
SELECT transcript FROM interview 
JOIN person ON interview.person_id = person.id 
WHERE person.address_street_name = "Franklin Ave" AND name LIKE "Annabel%";

--transcript of the interview: 
--"I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th."

-- Then, comparing the the list of suspects based on the interviews, we find the murderer:
SELECT * FROM get_fit_now_member
JOIN get_fit_now_check_in ON get_fit_now_member.id = get_fit_now_check_in.membership_id
WHERE get_fit_now_member.id LIKE "48Z%" 
AND get_fit_now_member.membership_status = "gold" 
AND get_fit_now_check_in.check_in_date = 20180109
AND get_fit_now_member.person_id IN 
(SELECT person.id FROM person 
JOIN drivers_license ON person.license_id = drivers_license.id
WHERE plate_number LIKE "%H42W%");

--It's Jeremy Bowers.

--Continuing to find the real villain behind the crime by looking at the transcipt of the murderer's interview:
SELECT * FROM interview
JOIN person ON interview.person_id = person.id 
WHERE name = "Jeremy Bowers";

--transcript of the interview: 
--"I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
--She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017."

-- Comparing the the list of suspects based on the murderer's interview:
SELECT person.id, name FROM drivers_license
JOIN person ON drivers_license.id = person.license_id
WHERE height IN (65, 66, 67) 
AND gender = "female"
AND hair_color = "red"
AND car_make = "Tesla"
AND car_model = "Model S"
AND person.id IN
(SELECT person_id FROM facebook_event_checkin
WHERE event_name = "SQL Symphony Concert"
AND date > 20171130 AND date < 20180101
GROUP BY person_id
HAVING count(*)=3);

--The villain is Miranda Priestly.


