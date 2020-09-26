# Django ORM (QuerySet) 구조와 원리 그리고 최적화전략

## Lazy Loading

- ORM에서는 필요한 시점에만 SQL을 호출한다. (lazy loading 지연로딩)
- 정말로 사용하지않으면 Query set은 SQL을 호출하지 않는다.
- user.objects.all()을 모든 유저를 정의하더라도, users[0]만 한다면 1명만 얻기 위해 LIMIT 1 옵션이 걸린 상태로 SQL을 호출한다.
- 한번만 호출해서 가져와도 되지만, ORM은 이후 로직을 모르기 떄문에 필요한 시점에 필요한 것만 가져오기 때문에 비효율적
- List(user) = list(users) -> 호출하는 순서만 바뀌는 것으로 쿼리셋 캐싱을 통해 개선가능. 따라서 쿼리셋 캐싱을 재사용하는 법으로 해결해야 함.

## Eager Loading

- Eager Loading 즉시로딩 : N + 1 Problem
- 즉시로딩을 하기위해, 즉, (N +1) 해결을 위해 django에서는 select_realated()와 prefetched_related() 메서드를 사용한다.
- for문을 돌 때마다 조회할 때마다 sql이 계속 호출되는 문제를 N + 1 문제라고 함
- (유저를 호출하는 sql 한번) + (유저 개수 N) = (N + 1 개의 쿼리)
- QuerySet은 1개의 쿼리와 0~N개의 추리쿼리 셋으로 구성되어 있다.
- prefetched_related : 추가쿼리 셋
- 호출할 때 result cache(SQL의 결과를 저장해놓고 재사용) 에 원하는 데이터가 없으면 쿼리셋 호출

- select_realated() : 조인을 통해 즉시로딩
- prefetched_related() : 추가 쿼리를 사용하여 즉시로딩(정보를 전부 끌어오겠다)
- 역참조는 select_related 옵션을 줄수 없음.django에서 제약이 있는 부분.
- prefetched_related 에 선언한 속성 개수만큼 queryset이 추가로 호출됨
- 테스트할 assertNumQueries()로 테스트케이스를 작성하지만 매번 체크를 해줘야되는 문제 (꼼꼼하게 볼 수 있겠지만), N+1문제로 인한 크리티컬한 성능 이슈만 커버하기 위해, captureQueriesContext를 활용하는 것이 도움됨

## QuerySet 사용에서 실수하기 쉬운 점들

- prefetched_related()는 추가 쿼리셋에서 제어
- filter()는 새로운 쿼리셋이 아니라 한 개 쿼리셋 안에서 제어
- 혼용하는 문제를 해결을 위해 prefeted_related 옵션을 제거하거나 / prefetch()에 조건을 넣도록 한다.
- annotate – select_related – filter – prefetch_related 순서가 실제 SQL 순서와 가장 유사하므로 이 순서로 QuerySet을 작성하는 것이 추천된다.
- Queryset 캐시를 재활용하지 못할 때가 있다. .all로 질의하면 캐시를 재활용하지만, 특정 상품을 찾으려고 하면 캐시를 재사용하지 않고 sql로 질의. 쿼리셋을 재호출하지않으려면 .all로 불러온 것에서 if 절을 활용하여 리스트 컴프리헨션으로 빼오는 것을 추천한다.
- raw 쿼리셋은 쿼리셋의 또 다른 유형이기 때문에 prefetch_related(), Prefetch() 사용이 가능하다. NativeSQL이 아닌 이유는 위의 옵션을 사용할 수 있다는 점에서 볼 수 있음.
- 서브 쿼리의 발생 조건이 두 가지 있다.
- 쿼리셋 안에 쿼리셋이 존재할 때 -> 리스트로 감싸서 해결 가능
- 역방향 참조모델에서(정방향은 해당X) exclude() 조건절에 조인이 되지않고 서브쿼리(슬로우쿼리)로 발생. JOIN으로 풀리는 것이 안되기 때문에, prefetched_related 옵션을 통해 해결.
- values(), values_list() 사용시에 EagerLoading 옵션 무시(select_related, prefetched_related 옵션 무시) (DB raw 단위로 한줄 한줄로 데이터 반환 object와 relational간에 apping이 일어나지 않기 때문)
- 복잡한 ORM이 있다면 NativeSQL로 작성하는 것을 망설이지 말자
