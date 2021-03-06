xquery version "3.0";

module namespace app="http://exist-db.org/apps/snutrition/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://exist-db.org/apps/snutrition/config" at "config.xqm";

(:~
 : This is a sample templating function. It will be called by the templating module if
 : it encounters an HTML element with an attribute data-template="app:test" 
 : or class="app:test" (deprecated). The function has to take at least 2 default
 : parameters. Additional parameters will be mapped to matching request or session parameters.
 : 
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:test($node as node(), $model as map(*)) {
    <p>Dummy template output generated by function app:test at {current-dateTime()}. The templating
        function was triggered by the class attribute <code>class="app:test"</code>.</p>
};

declare function app:simplequery($node as node(), $model as map(*), $query as xs:string?) {
    if($query) then(
        for $i in fn:doc("../results.xml")//foods/food
        where(
            fn:contains(fn:upper-case($i/name/text()), fn:upper-case($query))
            )
        return 
        (
            <tr>
                <td>{$i/name/text()}</td>
                <!--<td>{$i/measures/following-sibling::measure[1]/nutrient/name/text()}</td>
                <td>Protein</td>
                <td>Value</td>
                <td>Group</td>-->
                <td><a type="button" class="btn btn-round btn-info" href="details.html?id={$i/id/text()}">More Info</a></td>
            </tr>
        )
    )
    else(
        
        )
};

declare function app:loadAllFoad($node as node(), $model as map(*)) {
    for $i in fn:doc("../results.xml")//foods/food
    return 
    (
        <tr>
            <td>{$i/name/text()}</td>
            <td><a type="button" class="btn btn-round btn-info" href="details.html?id={$i/id/text()}" target="_blank">More Info</a></td>
            <td><a type="button" class="btn btn-round btn-success" name="{$i/id/text()}">Add</a></td>
        </tr>
    )
};

declare function app:searchquery($node as node(), $model as map(*), $query as xs:string?) {
    if($query) then(
        let $searchQuery := $query
        return 
        (
           <hr>
           <h1>Result for "{$searchQuery}"</h1>
           </hr>
        )
    )
    else()
};

declare function app:itemdetailname($node as node(), $model as map(*), $id as xs:string?) {
    if($id) then(
        let $itemName := $id
        for $i in fn:doc("../results.xml")//foods/food
        where(
            $i/id/text() eq $id
            ) 
        return 
        (
           <span>{xs:string(" ")} {$i/name/text()}</span>
        )
    )
    else()
};

declare function app:fooddetail($node as node(), $model as map(*), $id as xs:string?) {
    if($id) then(
        for $food in fn:doc("../results.xml")//foods/food
        where(
            $food/id/text() eq $id
            )
        return 
        (
            for $measure in ($food/measures/measure)
            return
            (
                    for $nutrient in $measure/nutrient
                    return
                    (
                        <tr>
                            <td>{xs:string($measure/@label)}</td>
                            <td>{xs:string($nutrient/name)}</td>
                            <td>{xs:string($nutrient/value)}{xs:string(" ")}{xs:string($nutrient/value/@unit)}</td>
                            <td>{xs:string($nutrient/group)}</td>
                        </tr>
                    )
            )
        )
    )
    else()
};

declare function app:loadPlans($node as node(), $model as map(*)) {
     for $plan in fn:doc("../user01.xml")//user/mealPlans/mealPlan
        return
        (
        <tr>
            <td>{$plan/name}</td>
            <td>{fn:count($plan/meals/meal)}</td>
            <!--<td>TODO</td>-->
            <td>
                 <a title="Open" class="btn btn-success btn-sm" style="margin-right: 10px" href="plan.html?id={$plan/id/text()}">
                    <span class="glyphicon glyphicon-eye-open" aria-hidden="true"/>
                </a>
                <a title="Edit" class="btn btn-warning btn-sm" style="margin-right: 10px" href="edit.html?id={$plan/id/text()}">
                    <span class="glyphicon glyphicon-edit" aria-hidden="true"/>
                </a>
                <a title="Remove" class="btn btn-danger btn-sm" href="">
                    <span class="glyphicon glyphicon-remove" aria-hidden="true"/>
                </a>
            </td>
        </tr>
        )
};

declare function app:searchmeals($node as node(), $model as map(*), $id as xs:string?) {
    if($id) then(
let $plan := fn:doc("../user01.xml")//user/mealPlans/mealPlan[id/text() eq $id]
for $meal in $plan/meals/meal
return (
<div>
<h4>
{xs:string($meal/@name)}
</h4>
<div class="content-panel">
<table id="table" class="table table-striped table-hover dt-responsive" cellspacing="0" width="100%">
<thead>
    <tr>
        <th>Food Name</th>
        <th>Measure</th>
        <th>Quantity</th>
        <th>Protein</th>
        <th>Total lipid</th>
        <th>Carbohydrate</th>
        <th>Energy</th>
        <th>Water</th>
        <th>Caffeine</th>
        <th>Sugars</th>
        <th>Fiber</th>
    </tr>
    </thead>
    <tbody>
    {
        for $food in $meal/food
        let $foodinfo := fn:doc("../foods.xml")//foods/food[id/text() eq $food/id/text()]
        let $measure := xs:string($food/@measure)
        return
        (
            <tr>
            <td><a href="details.html?id={$food/id/text()}">{$foodinfo/name/text()}</a></td>
            <td>{$measure}</td>
            <td>{$food/qt/text()}</td>
            {
                for $nutrient in $foodinfo/measures/measure[@label eq $measure]/nutrient
                return if(xs:integer($nutrient/@nutrient_id) le xs:integer(291))
                then (<td>{$nutrient/value/text()}</td>) else()
            }
            </tr>
         )
    }
   </tbody>
  </table>
 </div><!-- /content-panel -->
 <br></br>
 </div>
)
)
else(<h1>INVALID</h1>)
};

declare function app:teste($id as xs:string) {
    for $plan in fn:doc("../user01.xml")//user/mealPlans/mealPlan
    where $plan/@id = $id
    return
        update delete $plan
};

declare function app:height($node as node(), $model as map(*)) {
    let $x := (doc("../user01.xml")/user/registers/register[fn:last()]/height/text())
     return (<h3> {$x} m</h3>)
};

declare function app:weight($node as node(), $model as map(*)) {
    let $x := (doc("../user01.xml")/user/registers/register[fn:last()]/weight/text())
     return (<h3> {$x} Kg</h3>)
};

declare function app:imc($node as node(), $model as map(*)) {
    let $x := round-half-to-even(xs:double(doc("../user01.xml")/user/registers/register[fn:last()]/IMC/text()),2)
     return (<h3> {$x}</h3>)
};

declare function app:compareheight($node as node(), $model as map(*)) {
    let $x := (doc("../user01.xml")/user/registers/register[fn:last()]/height/text())
    let $y := (doc("../user01.xml")/user/registers/register[fn:last()-1]/height/text())
     return (if(xs:double($x)< xs:double($y)) then <p>You are shorter than last week! How could it be possible?</p>
     else if(xs:double($x)> xs:double($y)) then <p>You grew up since last week!</p>
     else <p>You are the same height as last week.</p>)
};

declare function app:compareweight($node as node(), $model as map(*)) {
    let $x := (doc("../user01.xml")/user/registers/register[fn:last()]/weight/text())
    let $y := (doc("../user01.xml")/user/registers/register[fn:last()-1]/weight/text())
     return (if(xs:double($x)< xs:double($y)) then <p>You have lost some weight since last week.</p>
     else if(xs:double($x)> xs:double($y)) then <p>You have gained some weight since last week.</p>
     else <p>You are the same weight as last week.</p>)
};

declare function app:compareimc($node as node(), $model as map(*)) {
    let $x := (doc("../user01.xml")/user/registers/register[fn:last()]/IMC/text())
    let $y := (doc("../user01.xml")/user/registers/register[fn:last()-1]/IMC/text())
     return (if(xs:double($x)< xs:double($y)) then <p>Your BMI fell since last week.</p>
     else if(xs:double($x)> xs:double($y)) then <p>Your BMI have increased since last week.</p>
     else <p>Your BMI stays the same as last week.</p>)
};

declare function app:insertNewRegister($node as node(), $model as map(*), $id as xs:string?) {
    let $log-in := xmldb:login("/db", "admin", "lapdsm")
    let $data-collection := '/db/apps/terms/data'
    let $peso := xs:float(request:get-parameter('peso', ""))
    let $altura := xs:float(request:get-parameter('altura', ""))
    let $registers := fn:doc("../user01.xml")//registers
    let $bmi := $peso div ($altura * $altura)
    let $lastRegisterId := xs:integer($registers//register[fn:last()]/id)
    let $date := fn:current-date()
return 
    update insert <register>
    <id> {$lastRegisterId + 1} </id>
    <date>{$date}</date>
    <weight unit="Kg">{$peso}</weight>
    <height unit="m">{$altura}</height>
    <IMC>{$bmi}</IMC>
    <activityLevel>Medium</activityLevel>
</register> following $registers//register[fn:last()]
};

declare function app:insertNewMealPlan($node as node(), $model as map(*), $name as xs:string?) {
    let $log-in := xmldb:login("/db", "admin", "lapdsm")
    let $data-collection := '/db/apps/terms/data'
    let $name := xs:string(request:get-parameter('name', ""))
    let $mealPlans := fn:doc("../user01.xml")//mealPlans 
    let $lastMealPlanId := xs:integer($mealPlans//mealPlan[fn:last()]/id)
return 
    update insert <mealPlan>
                        <id>{$lastMealPlanId + 1}</id>
                        <name>{$name}</name>
                        <meals> 
                            
                        </meals> 
                    </mealPlan>
                    following $mealPlans//mealPlan[fn:last()]
};

declare function app:insertNewMeal($node as node(), $model as map(*), $name as xs:string?) {
    let $log-in := xmldb:login("/db", "admin", "lapdsm")
    let $data-collection := '/db/apps/terms/data'
    let $lastMealplanMeals := fn:doc("../user01.xml")//mealPlans/mealPlan[fn:last()]/meals
return 
    update insert <meal name="{$name}">
                    <id>1</id>
                    <hour> 16:00 </hour>
                    </meal>
                    into $lastMealplanMeals
};

declare function app:getLastAnthropometricRegister($node as node(), $model as map(*), $id as xs:string?) {
    let $log-in := xmldb:login("/db", "admin", "lapdsm")
    let $registers := fn:doc("../user01.xml")//registers
    let $const := 0.45359237
    let $lastRegister := $registers//register[fn:last()]
    let $weight := $lastRegister/weight/text()
    let $weightinpounds := xs:float($weight) div $const
    let $height := $lastRegister/height/text()
    let $IMC := round-half-to-even(xs:double($lastRegister/IMC/text()), 2)
    let $gender := (doc("../user01.xml")/user/gender/text())
    let $activityLevel := (doc("../user01.xml")/user/registers/register/activityLevel/text())
    let $bmrmale := $weightinpounds*10
    let $bmrfemale := $weightinpounds*11
    
    let $cal := (if(equals($gender, "Male") and (equals($activityLevel, "Low"))) then $bmrmale*1.2
    else if(equals($gender, "Male") and (equals($activityLevel, "Medium"))) then  $bmrmale*1.55
    else if(equals($gender, "Male") and (equals($activityLevel, "High"))) then $bmrmale*1.725
    else if(equals($gender, "Female") and (equals($activityLevel, "Low"))) then $bmrfemale*1.2
    else if(equals($gender, "Female") and (equals($activityLevel, "Medium"))) then $bmrfemale*1.55
    else $bmrfemale*1.725)
    
return
    (
        <div>
        <div class="grey-header">
                <h5>Current  ({fn:substring($lastRegister/date/text(),1,10)})</h5>
            </div>
            <div class="row">
                <div class="col-sm-6 col-xs-6">
                    <h3>Weight</h3>
                    <h3>Height</h3>
                    <h3>BMI</h3>
                    <h3> Caloric intake</h3>
                </div>
                <div class="col-sm-6 col-xs-6">
                <h3>{$weight} Kg</h3>
                <h3>{$height} m</h3>
                <h3>{$IMC}</h3>
                <h3>{xs:integer($cal)} cal/day</h3>
        </div>
        </div>
        </div>
    )
};

declare function app:getNumPlans($node as node(), $model as map(*)) {
    let $mealPlans := doc("../user01.xml")/user/mealPlans/mealPlan
    let $numPlans := count($mealPlans)
     return (<h3> {$numPlans} </h3>)
};

declare function app:getLatestMealPlan($node as node(), $model as map(*)) {
    let $latestMealPlans := doc("../user01.xml")/user/mealPlans/mealPlan[fn:last()]
    let $latestMealPlanId := xs:integer($latestMealPlans/id/text())
    let $latestMealPlanMeals := $latestMealPlans/meals
    for $meal in $latestMealPlanMeals/meal
    let $hour := $meal/hour/text()
    let $foodLabel := data($meal/@name)
     return 
         (
             <div class="desc">
                <div class="thumb">
                    <span class="badge bg-theme">
                        <i class="fa fa-clock-o"/>
                    </span>
                </div>
                <div class="details">
                    <p>
                        <muted>{$hour}</muted>
                        <br/>
                        <a href="plan.html?id={$latestMealPlanId}">{$foodLabel}</a>
                    </p>
                </div>
            </div>
         )
};

declare function app:calcularcal($node as node(), $model as map(*)) {
    let $const := 0.45359237
    let $gender := (doc("../user01.xml")/user/gender/text())
    let $activityLevel := (doc("../user01.xml")/user/registers/register/activityLevel/text())
    let $weight := xs:float(doc("../user01.xml")/user/registers/register[fn:last()]/weight/text()) div $const
    let $bmrmale := $weight*10
    let $bmrfemale := $weight*11
    
    let $resultado := (if(equals($gender, "Male") and (equals($activityLevel, "Low"))) then $bmrmale*1.2
    else if(equals($gender, "Male") and (equals($activityLevel, "Medium"))) then  $bmrmale*1.55
    else if(equals($gender, "Male") and (equals($activityLevel, "High"))) then $bmrmale*1.725
    else if(equals($gender, "Female") and (equals($activityLevel, "Low"))) then $bmrfemale*1.2
    else if(equals($gender, "Female") and (equals($activityLevel, "Medium"))) then $bmrfemale*1.55
    else $bmrfemale*1.725)
    return $resultado 
};
