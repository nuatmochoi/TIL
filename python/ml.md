# 분류

## scikit-learn
- fit, score(정확도), predict

- `np.column_stack()` : column으로 데이터가 합쳐짐
- `np.concatenate()` : list로 합쳐짐

- `train_test_split()` : 훈련 세트와 테스트 세트 나누기

- 스케일이 다른 속성 처리 --> 표준점수(`z = (데이터-평균)/표준편차`)

# 회귀
- kNN 회귀
- `knr.score()` : 결정계수
- `mean_absolute_error` : 타깃과 예측의 절대값 오차를 평균 
    - error = 타깃 - 예측
- 오버피팅 - knn의 경우 k 값을 늘림 (덜 복잡한 모델 사용, default 값 == 5)
- 언더피팅 - knn의 경우 k 값을 줄임 (더 복잡한 모델 사용)
